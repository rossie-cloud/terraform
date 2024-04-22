variable "project" {
  description = "Project ID"
  type        = string
  default     = "perfect-day-417915"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone"
  type        = string
  default     = "us-central1-c"
}

variable "name" {
  description = "prefix for all resources created in this example"
  type        = string
  default     = "newexamplet"
}
/*
variable "cloud_run_name" {
  description = "Cloud Run Name"
  type        = string
  default     = "helloworld-python"
}
*/
/*
variable "external_ip" {
  description = "Reserved global IPv4"
  type        = string
  default     = "34.36.219.212"
}
*/

variable "ssl_certificate" {
  description = "Self-signed SSL Certficate"
  type        = string
  default     = "functions-ssl-cert"
}


variable "dns_zone" {
  description = "The DNS zone you'll add the IP address to"
  type        = string
  default     = "my-public-zone"
}
