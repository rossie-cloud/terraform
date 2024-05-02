output "weapp_url" {
  value = module.load_balancer.url
}


# env/res/outputs.tf
output "bucket_name" {
  value = google_storage_bucket.bucket.name
}
