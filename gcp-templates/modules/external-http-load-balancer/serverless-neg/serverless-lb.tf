resource "google_compute_global_address" "default" {
  name = "${var.name_prefix}-address"
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "${var.name_prefix}-cert"
  managed {
    domains = ["${var.domain}"]
  }
}

resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  provider              = google-beta
  name                  = "${var.name_prefix}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_function {
    function = "${var.name_prefix}-function"
  }
}

resource "google_compute_backend_service" "default" {
  name = "${var.name_prefix}-backend"

  enable_cdn  = var.enable_cdn
  protocol    = "HTTPS"
  port_name   = "http"
  timeout_sec = 30

  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_neg.id
  }
}

resource "google_compute_url_map" "default" {
  name = "${var.name_prefix}-urlmap"

  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_https_proxy" "default" {
  name = "${var.name_prefix}-https-proxy"

  url_map = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.default.id
  ]
}

resource "google_compute_global_forwarding_rule" "default" {
  name = "${var.name_prefix}-lb"

  target     = google_compute_target_https_proxy.default.id
  port_range = "443"
  ip_address = google_compute_global_address.default.address

}

resource "google_compute_url_map" "https_redirect" {
  name = "${var.name_prefix}-https-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "https_redirect" {
  name    = "${var.name_prefix}-http-proxy"
  url_map = google_compute_url_map.https_redirect.id
}

resource "google_compute_global_forwarding_rule" "https_redirect" {
  name = "${var.name_prefix}-lb-http"

  target     = google_compute_target_http_proxy.https_redirect.id
  port_range = "80"
  ip_address = google_compute_global_address.default.address
}

# fetching already created DNS zone
data "google_dns_managed_zone" "env_dns_zone" {
  name = var.dns_zone

}

# to register web-server's ip address in DNS
resource "google_dns_record_set" "default" {
  name         = "functions.${data.google_dns_managed_zone.env_dns_zone.dns_name}"
  managed_zone = data.google_dns_managed_zone.env_dns_zone.name
  type         = "A"
  ttl          = 300
  rrdatas = [
    google_compute_global_address.default.address
  ]
}