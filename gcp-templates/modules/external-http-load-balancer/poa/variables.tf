## common
variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "name_prefix" {
  type        = string
  description = "prefix for all resources created in this example"
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

variable "timestamp" {
  type        = string
  description = "To pass a random string that will change everythinme code is executed"
}

variable "fqdn" {
  type        = string
  description = "The fully qualified domain name of the GCS bucket"
}
