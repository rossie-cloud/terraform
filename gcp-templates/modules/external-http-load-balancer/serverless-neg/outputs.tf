output "lb_ip" {
  value = google_compute_global_address.default.address
}

output "url" {
  value = "https://${google_dns_record_set.default.name}"
}