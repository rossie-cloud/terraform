output "lb_ip" {
  value = "https:${google_compute_global_address.default.address}"
}

output "url" {
  value = "https://${trim(google_dns_record_set.default.name,".")}"
}