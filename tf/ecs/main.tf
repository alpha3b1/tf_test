resource "aws_cloudwatch_log_group" "log_group" {
  name              = "awslogs-${var.app}-svc"
  retention_in_days = var.log_retention_days

  tags = {
    Environment = upper(var.env)
    Application = var.app
  }
}


resource "aws_ecs_task_definition" "task_def" {
  family                   = "${var.env}-${var.task_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_fargate_cpu
  memory                   = var.ecs_fargate_memory
  execution_role_arn       = var.exec_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions    = var.container_defs


}

resource "aws_ecs_service" "ecs_service" {
  name                              = "${var.app}-svc"
  cluster                           = var.ecs_cluster_id
  task_definition                   = aws_ecs_task_definition.task_def.arn
  desired_count                     = var.stack_on ? var.app_count : 0
  launch_type                       = "FARGATE"
  enable_execute_command            = true
  health_check_grace_period_seconds = 600

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    security_groups = var.sec_groups
    subnets         = var.subnets
  }

  load_balancer {
    target_group_arn = var.lb_tg
    container_name   = var.container_name
    container_port   = var.app_port
  }

}

