locals {
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
}

module "load_balancer" {
  source = "../../modules/external-http-load-balancer/poa"

  project_id  = var.project_id
  name_prefix = var.name_prefix

  domain     = var.domain
  dns_zone   = var.dns_zone
  enable_cdn = var.enable_cdn

  fqdn = "${google_storage_bucket.bucket.name}.storage.googleapis.com"

  timestamp = local.timestamp
}

resource "google_storage_bucket" "bucket" {
  name                        = "${var.name_prefix}-bucket-${local.timestamp}"
  location                    = var.location
  uniform_bucket_level_access = true

  storage_class            = "STANDARD"
  force_destroy            = true
  public_access_prevention = "enforced"
}

resource "google_storage_bucket_object" "indexpage" {
  source       = "./website/index.html"
  content_type = "text/html"

  name   = "index.html"
  bucket = google_storage_bucket.bucket.name
}

resource "google_storage_bucket_object" "image" {
  source       = "./website/image.png"
  content_type = "image/png"

  name   = "image.png"
  bucket = google_storage_bucket.bucket.name
}

# Create a new service account
resource "google_service_account" "service_account" {
  account_id = "my-svc-acc-${local.timestamp}"
}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

#Create the HMAC key for the associated service account 
resource "google_storage_hmac_key" "key" {
  service_account_email = google_service_account.service_account.email
}
