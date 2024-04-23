module "load_balancer" {
  source = "../../modules/http-load-balancer"

  project = var.project
  name   = var.name
  region = var.region

  domain   = var.domain
  dns_zone = var.dns_zone
  
  cloud_function = google_cloudfunctions_function.function.name
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = "./app"
  output_path = "./function.zip"
}

resource "google_storage_bucket" "bucket" {
  name     = "test-bucket-${var.name}-${random_id.ids.dec}"
  location = "US"
}

resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"

  name   = "src-${var.name}-${random_id.ids.dec}.zip"
  bucket = google_storage_bucket.bucket.name
}

resource "google_cloudfunctions_function" "function" {
  name    = "${var.name}-function"
  runtime = "python312"
  region  = var.region

  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.zip.name
  entry_point           = "hello_world"
  trigger_http          = true

  ingress_settings = "ALLOW_INTERNAL_AND_GCLB"
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