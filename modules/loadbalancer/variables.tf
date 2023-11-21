locals {
  region = "eu-west-1"
  env    = terraform.workspace
}

variable "web_traffic" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
