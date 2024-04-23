## common
variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "region" {
  type        = string
  description = "Region"
}

variable "name_prefix" {
  type        = string
  description = "prefix for all resources created in this example"
}

variable "owner" {
  description = "The owner which will be tagged on all resources"
  type        = string
}

## templates
# http serverless lb
variable "domain" {
  type        = string
  description = "Domain for which the SSL certificate will be valid"
}

variable "dns_zone" {
  type        = string
  description = "The DNS zone you'll add the IP address to"
}

variable "enable_cdn" {
  type        = string
  description = "Enables CDN for the backend service"
}