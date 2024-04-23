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

variable "owner" {
  description = "The owner which will be tagged on all resources"
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

# cloud funtion
variable "ingress_settings" {
  description = "The traffic that can reach the function. Changes to this will re-create the function"
  type        = string
}

# webapp
variable "entry_point" {
  description = "The DNS zone you'll add the IP address to"
  type        = string
}

variable "runtime" {
  description = "The runtime which the function is going to run"
  type        = string
}