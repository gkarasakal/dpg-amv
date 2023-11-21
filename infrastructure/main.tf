locals {
  terraform_variables = jsondecode(file("${path.module}/variables.json"))
}

module "vpc" {
  source              = "../modules/vpc"
  vpc_cidr_block      = local.terraform_variables.variable.vpc_cidr_blocks.default
  env                 = local.terraform_variables.locals.env
  private_cidr_blocks = local.terraform_variables.variable.private_cidr_blocks.default[*]
  public_cidr_blocks  = local.terraform_variables.variable.public_cidr_blocks.default[*]
}

module "loadbalancer" {
  source              = "../modules/loadbalancer"
  subnets             = module.vpc.public_subnet.*.id
  vpc_id              = module.vpc.vpc_id
  web_traffic         = local.terraform_variables.variable.web_traffic.default
}

module "autoscaling" {
  source              = "../modules/autoscaling"
  vpc_id              = module.vpc.vpc_id
  alb_sg              = module.loadbalancer.dpg_amv_alb_sg_id
  private_subnet_id   = module.vpc.private_subnet[0].id
  public_subnet_id    = module.vpc.public_subnet[0].id
  target_group_arns   = module.loadbalancer.dpg_amv_http_target_group
}
