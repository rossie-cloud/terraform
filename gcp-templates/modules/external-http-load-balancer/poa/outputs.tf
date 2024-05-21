output "lb_ip" {
  value = "https:${google_compute_global_address.default.address}"
}

/*
output "url" {
  value = "https://${trim(google_dns_record_set.default.name, ".")}"
}
*/

/*
output "accessKeyId" {
  value = google_storage_hmac_key.key.access_id
}

output "accessKey" {
  value = google_storage_hmac_key.key.secret
}
*/

output "backend_service" {
  value = google_compute_backend_service.default.name 
}