variable "project" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "name" {
  description = "prefix for all resources created in this example"
  type        = string
}

variable "domain" {
  description = "Domain for which the SSL certificate will be valid"
  type        = string
}

variable "dns_zone" {
  description = "The DNS zone you'll add the IP address to"
  type        = string
}