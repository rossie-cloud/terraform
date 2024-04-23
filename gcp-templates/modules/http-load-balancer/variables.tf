variable "project" {
  type        = string
  description = "Project ID"
}

variable "region" {
  type        = string
  description = "Region"
}

variable "domain" {
  type        = string
  description = "Domain for which the SSL certificate will be valid"
}

variable "name" {
  type        = string
  description = "prefix for all resources created in this example"
}

variable "dns_zone" {
  type        = string
  description = "The DNS zone you'll add the IP address to"
}