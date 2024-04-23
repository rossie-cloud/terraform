variable "project" {
  type        = string
  description = "Project ID"
}

variable "region" {
  type        = string
  description = "Region"
}

variable "name" {
  type        = string
  description = "prefix for all resources created in this example"
}

variable "domain" {
  type        = string
  description = "Domain for which the SSL certificate will be valid"
}

variable "dns_zone" {
  type        = string
  description = "The DNS zone you'll add the IP address to"
}

variable "cloud_function" {
  description = "Cloud Func"
  type        = string
}