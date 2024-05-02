## common
variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "name_prefix" {
  description = "prefix for all resources created in this example"
  type        = string
}

## templates
# http serverless lb
variable "domain" {
  description = "Domain for which the SSL certificate will be valid"
  type        = string
}

variable "dns_zone" {
  description = "The DNS zone you'll add the IP address to"
  type        = string
}

variable "enable_cdn" {
  type        = string
  description = "Enables CDN for the backend service"
}

# gcs
variable "location" {
  description = "The GCS location. Can't be changed"
  type        = string
}
/*
variable "timestamp" {
  type        = string
  description = "To pass a random string that will change everythinme code is executed"
}*/