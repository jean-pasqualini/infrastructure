variable "credentials" {
  description = "Path to json google auth credentials"
}

variable "region" {
  default = "europe-west1"
}

variable "region_zone" {
  default = "europe-west1-b"
}

variable "project_name" {
  description = "The ID of the Google Cloud project"
  default = "run-melody"
}

variable "domain" {
  description = "The domain name"
  default = "local.io."
}