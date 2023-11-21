module "vpc" {
  source              = "../modules/vpc"
  env                 = local.env
  private_cidr_blocks = var.private_cidr_blocks[local.env]
  public_cidr_blocks  = var.public_cidr_blocks[local.env]
  vpc_cidr_block      = var.vpc_cidr_block[local.env]
}

module "loadbalancer" {
  source              = "../modules/loadbalancer"
  subnets             = local.public_subnet_ids
  vpc_id              = local.vpc_id
  web_traffic         = local.web_traffic[local.env]
}

module "autoscaling" {
  source              = "../modules/autoscaling"
  vpc_id              = local.vpc_id
  alb_sg              = module.loadbalancer.dpg_amv_alb_sg_id
  private_subnet_id   = module.vpc.private_subnet[0].id
  public_subnet_id    = module.vpc.public_subnet[0].id
  target_group_arns   = module.loadbalancer.dpg_amv_http_target_group
}
