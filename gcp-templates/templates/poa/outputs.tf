/*
output "weapp_url" {
  value = module.load_balancer.url
}
*/

# env/res/outputs.tf
output "bucket_name" {
  value = google_storage_bucket.bucket.name
}

output "fqdn" {
  value = "${google_storage_bucket.bucket.name}.storage.googleapis.com"
}

output "accessKeyId" {
  value = google_storage_hmac_key.key.access_id
}

output "accessKey" {
  value = nonsensitive(google_storage_hmac_key.key.secret)
}

output "backend_service" {
  value = module.load_balancer.backend_service
}
