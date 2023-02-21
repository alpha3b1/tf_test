data "template_file" "env_vars" {
  template = file("resources/env_vars.json")

  vars = {
    aws_access_key_id      = var.aws_access_key
    aws_secret_access_key  = var.aws_secret_key
    aws_s3_bucket_name = aws_s3_bucket.this.id
  }
}


locals {
  ecr_url="${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com"
  task_name           = "${var.app}-task"
  service_name        = "${var.app}-svc"
  cluster_name        = "${var.app}-${var.env}"
  svcs_env_vars = data.template_file.env_vars.rendered
  svcs_container_def = templatefile("resources/task_def.tmpl",
    {
      region      = var.aws_region
      ecr_url     = local.ecr_url
      image_tag   = var.image_tag
      task_name   = local.task_name
      image_name  = "pyxis/web-app"
      container_name = var.container_name
      app_port    = 5000
      environment = local.svcs_env_vars
      env         = var.env
  })
}


# Create ECS Cluster
resource "aws_ecs_cluster" "idm_cluster" {
  name = local.cluster_name
}


module "ecs_service" {
  source = "./ecs"

  task_name = local.task_name
  #   ecr_repo           = aws_ecr_repository.metro_services.name
  container_defs     = local.svcs_container_def
  log_retention_days = 14
  ecs_fargate_cpu    = 512
  ecs_fargate_memory = 1024
  exec_role_arn      = aws_iam_role.ecs_task_exec_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  ecs_cluster_id     = aws_ecs_cluster.ecs_cluster.id
  stack_on           = true #set to zero to shutdown containers
  app_count          = 2
  sec_groups         = [module.networking.app_sg]
  subnets            = module.networking.private_subnets
  env                = var.env
  lb_tg              = module.elb.tg_id
  container_name     = var.container_name
  app                = var.app
  app_port           = 5000
  vpc_id             = module.networking.vpc_id

}

