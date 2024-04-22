resource "google_compute_global_address" "default" {
  name = "${var.name}-address"
}

resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  provider              = google-beta
  name                  = "${var.name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.cloud_run_name
  }
}

resource "google_compute_backend_service" "default" {
  name      = "${var.name}-backend"

  protocol  = "HTTPS"
  port_name = "http"
  timeout_sec = 30

  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_neg.id
  }
}

resource "google_compute_url_map" "default" {
  name            = "${var.name}-urlmap"

  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_https_proxy" "default" {
  name   = "${var.name}-https-proxy"

  url_map          = google_compute_url_map.default.id
  ssl_certificates = [
    var.ssl_certificate
  ]
}

resource "google_compute_global_forwarding_rule" "default" {
  name   = "${var.name}-lb"

  target = google_compute_target_https_proxy.default.id
  port_range = "443"
  ip_address = google_compute_global_address.default.address
}


resource "google_compute_url_map" "https_redirect" {
  name            = "${var.name}-https-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "https_redirect" {
  name   = "${var.name}-http-proxy"
  url_map          = google_compute_url_map.https_redirect.id
}

resource "google_compute_global_forwarding_rule" "https_redirect" {
  name   = "${var.name}-lb-http"

  target = google_compute_target_http_proxy.https_redirect.id
  port_range = "80"
  ip_address = google_compute_global_address.default.address
}

# fetching already created DNS zone
data "google_dns_managed_zone" "env_dns_zone" {
  name = var.dns_zone

}

# to register web-server's ip address in DNS
resource "google_dns_record_set" "default" {
  name         = "run.${data.google_dns_managed_zone.env_dns_zone.dns_name}"
  managed_zone = data.google_dns_managed_zone.env_dns_zone.name
  type         = "A"
  ttl          = 300
  rrdatas = [
    google_compute_global_address.default.address
  ]
}
