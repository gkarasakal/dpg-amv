locals {
  env = terraform.workspace

  private_subnet_ids        = tolist(
  module.vpc.private_subnet.*.id
  )

  public_subnet_ids = tolist(
  module.vpc.public_subnet.*.id
  )

  vpc_id = module.vpc.vpc_id

  web_traffic = {
    acceptance:[
      "0.0.0.0/0"]
    production:[
      "0.0.0.0/0"]
  }
}

variable "public_cidr_blocks" {
  type    = map(list(string))
  default = {
    acceptance: [
      "10.1.1.0/24",
      "10.1.2.0/24",
      "10.1.3.0/24"
    ],
    production: [
      "10.2.1.0/24",
      "10.2.2.0/24",
      "10.2.3.0/24"
    ]
  }
}

variable "private_cidr_blocks" {
  type    = map(list(string))
  default = {
    acceptance: [
      "10.1.4.0/24",
      "10.1.5.0/24",
      "10.1.6.0/24"
    ],
    production: [
      "10.2.4.0/24",
      "10.2.5.0/24",
      "10.2.6.0/24"
    ]
  }
}

variable "vpc_cidr_block" {
  type    = map(string)
  default = {
    acceptance: "10.1.0.0/16",
    production: "10.2.0.0/16"
  }
}
