resource "google_compute_global_address" "default" {
  name = "${var.name_prefix}-address-${var.timestamp}"
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "${var.name_prefix}-cert-${var.timestamp}"
  managed {
    domains = [var.domain]
  }
}

resource "google_compute_global_network_endpoint_group" "neg" {
  name                  = "${var.name_prefix}-my-lb-neg-${var.timestamp}"
  network_endpoint_type = "INTERNET_FQDN_PORT"
  default_port          = "443"
}

resource "google_compute_global_network_endpoint" "proxy" {
  provider                      = google-beta
  global_network_endpoint_group = google_compute_global_network_endpoint_group.neg.id
  fqdn                          = var.fqdn
  port                          = google_compute_global_network_endpoint_group.neg.default_port
}

resource "google_compute_backend_service" "default" {
  name = "${var.name_prefix}-backend-service-${var.timestamp}"

  protocol  = "HTTPS"
  port_name = "http"

  enable_cdn = true

  cdn_policy {
    cache_mode                   = "FORCE_CACHE_ALL"
    signed_url_cache_max_age_sec = "0"
    default_ttl                  = "3600"
    client_ttl                   = "3600"
    serve_while_stale            = "0"
  }

  timeout_sec                     = "30"
  connection_draining_timeout_sec = "0"

  custom_request_headers = ["host: ${google_compute_global_network_endpoint.proxy.fqdn}"]

  backend {
    group = google_compute_global_network_endpoint_group.neg.id
  }
}

# Create url map
resource "google_compute_url_map" "default" {
  name = "${var.name_prefix}-http-lb-${var.timestamp}"

  default_service = google_compute_backend_service.default.id
}

/*
# Create HTTP target proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "${var.name_prefix}-http-lb-proxy-${var.timestamp}"
  url_map = google_compute_url_map.default.id
}
*/

# Create HTTPS target proxy
resource "google_compute_target_https_proxy" "default" {
  name    = "${var.name_prefix}-https-lb-proxy-${var.timestamp}"
  url_map = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.default.id
  ]
}

# Create forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "${var.name_prefix}-http-lb-forwarding-rule-${var.timestamp}"
  load_balancing_scheme = "EXTERNAL" ## EXTERNAL - Classic lb ;; EXTERNAL_MANAGED - Global lb

  port_range = "443" ## 80 for http

  target     = google_compute_target_https_proxy.default.id
  ip_address = google_compute_global_address.default.id
}

resource "google_compute_url_map" "https_redirect" {
  name = "${var.name_prefix}-https-redirect-${var.timestamp}"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "https_redirect" {
  name    = "${var.name_prefix}-http-proxy-${var.timestamp}"
  url_map = google_compute_url_map.https_redirect.id
}

resource "google_compute_global_forwarding_rule" "https_redirect" {
  name = "${var.name_prefix}-lb-http-${var.timestamp}"

  target     = google_compute_target_http_proxy.https_redirect.id
  port_range = "80"
  ip_address = google_compute_global_address.default.address
}

# Fetching already created DNS zone
data "google_dns_managed_zone" "env_dns_zone" {
  name = var.dns_zone

}

# to register web-server's ip address in DNS
resource "google_dns_record_set" "default" {
  name         = "${var.domain}." ## data.google_dns_managed_zone.env_dns_zone.dns_name
  managed_zone = data.google_dns_managed_zone.env_dns_zone.name
  type         = "A"
  ttl          = 300
  rrdatas = [
    google_compute_global_address.default.address
  ]
}
