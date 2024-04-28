## common
name_prefix = "test1-20240423" #"ext-serverless-webapp"
owner       = "Automotive Cloud Center of Excellence"
project_id  = "perfect-day-417915"
region      = "us-central1"

## template
# http serverless lb
dns_zone = "my-public-zone"
domain   = "functions.rossie.cloud"
enable_cdn   = true

# gcs
location = "US"

# cloud funtion
ingress_settings = "ALLOW_INTERNAL_AND_GCLB"

# webapp
runtime          = "python312"
entry_point      = "hello_world"
