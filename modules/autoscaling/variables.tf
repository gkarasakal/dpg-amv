locals {
  env = terraform.workspace
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "target_group_arns" {
  type = string
}

variable "alb_sg" {
  type = string
}

variable "ami_id" {
  type    = string
  default = "ami-07355fe79b493752d"
}

variable "instance_type" {
  type    = map(string)
  default = {
    acceptance    = "t2.micro"
    production    = "t3.medium"
  }
}

variable "autoscaling_min" {
  type    = map(number)
  default = {
    acceptance    = "2"
    production    = "2"
  }
}

variable "autoscaling_max" {
  type    = map(number)
  default = {
    acceptance    = "4"
    production    = "8"
  }
}

variable "autoscaling_api_desired_capacity" {
  type    = map(number)
  default = {
    acceptance    = "2"
    production    = "2"
  }
}
