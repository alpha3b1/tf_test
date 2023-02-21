variable "task_name" {}
variable "app" {}
variable "log_retention_days" {}
variable "env" {}
variable "ecs_fargate_cpu" {}
variable "ecs_fargate_memory" {}
variable "exec_role_arn" {}
variable "task_role_arn" {}
variable "ecs_cluster_id" {}
variable "stack_on" {}
variable "app_count" {}
variable "sec_groups" {}
variable "subnets" {}
# variable "services" {
#   type = list(any)
# }
# variable "ecr_repo" {}
variable "lb_tg" {}
variable "container_name" {}
variable "app_port" {}
variable "container_defs" {}
variable "vpc_id" {}


