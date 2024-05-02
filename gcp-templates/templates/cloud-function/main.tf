module "load_balancer" {
  source = "../../modules/external-http-load-balancer-serverless-neg"

  project_id  = var.project_id
  region      = var.region
  name_prefix = var.name_prefix
  owner       = var.owner

  domain     = var.domain
  dns_zone   = var.dns_zone
  enable_cdn = var.enable_cdn
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = "./app"
  output_path = "./function.zip"
}

resource "google_storage_bucket" "bucket" {
  name     = "test-bucket-${var.name_prefix}-${random_id.ids.dec}"
  location = var.location

  #labels = local.Labels
}

resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"

  name   = "src-${var.name_prefix}-${random_id.ids.dec}.zip"
  bucket = google_storage_bucket.bucket.name
}

resource "google_cloudfunctions_function" "function" {
  name    = "${var.name_prefix}-function"
  runtime = var.runtime
  region  = var.region

  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.zip.name
  entry_point           = var.entry_point
  trigger_http          = true

  ingress_settings = var.ingress_settings

  #labels = local.Labels
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "random_id" "ids" {
  byte_length = 4
}