
provider "aws" {
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
  # region     = var.aws_region

  default_tags {
    tags = {
      "Environment" = var.env
      "Project" = var.app
    }
  }
}


data "aws_caller_identity" "current" {}


#-- Setup Networking

module "networking" {
  source          = "./networking"
  vpc_name        = "simple-${var.env}-vpc"
  vpc_cidr        = var.vpc_cidr
  access_ip       = var.access_ip
  max_subnets     = 20
  pub_sn_count    = 2
  priv_sn_count   = 2
  public_cidrs    = [for i in range(2, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_cidrs   = [for i in range(1, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  security_groups = local.security_groups
}

module "ec2" {
  source ="./ec2"
  subnets = module.networking.public_subnets
  security_groups = [module.networking.ssh_sg]
}


#-- Setup Load Balancing

module "elb" {
  lb_name                 = "app-lb"
  source                  = "./elb"
  public_sg               = module.networking.frontend_sg
  public_subnets          = module.networking.public_subnets
  tg_port                 = 80
  tg_protocol             = "HTTP"
  vpc_id                  = module.networking.vpc_id
  elb_healthy_threshold   = 2
  elb_unhealthy_threshold = 2
  elb_timeout             = 3
  elb_interval            = 30
  listener_port           = 80
  health_check_path       = "/"
}

#
# # The app Will block any traffic not comming from frontend lb
# #
# resource "aws_security_group_rule" "be_rule" {
#   type              = "ingress"
#   from_port         = 5000
#   to_port           = 5000
#   protocol          = "tcp"
#   security_group_id = module.networking.app_sg
#   source_security_group_id = module.networking.frontend_sg
# }

