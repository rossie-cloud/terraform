locals {
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
  bucket_name = google_storage_bucket.bucket.name
}

module "load_balancer" {
  source = "../../modules/external-http-load-balancer/backend-bucket"

  project_id  = var.project_id
  region      = var.region
  name_prefix = var.name_prefix

  domain     = var.domain
  dns_zone   = var.dns_zone
  enable_cdn = var.enable_cdn

  timestamp = local.timestamp
  # bucket_name = local.bucket_name
}

resource "google_storage_bucket" "bucket" {
  name                        = "${var.name_prefix}-bucket-${local.timestamp}"
  location                    = var.location
  uniform_bucket_level_access = true

  storage_class = "STANDARD"
  // delete bucket and contents on destroy.
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    # not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_object" "indexpage" {
  source       = "index.html"
  content_type = "text/html"

  name   = "index.html"
  bucket = google_storage_bucket.bucket.name
}

resource "google_storage_bucket_object" "imagen" {
  source       = "image.png"
  content_type = "image/png"

  name   = "image.png"
  bucket = google_storage_bucket.bucket.name
}

# Make buckets public
resource "google_storage_bucket_iam_member" "bucket" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
