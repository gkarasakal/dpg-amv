locals {
  region = "eu-west-1"
}

provider "aws" {
  region              =  local.region
}

terraform {
  required_version = "1.6.4"
  required_providers {
    aws = {
      version      = "5.25.0"
    }
  }
}
