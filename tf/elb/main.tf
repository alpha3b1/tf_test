resource "aws_lb" "this" {
  name            = var.lb_name
  subnets         = var.public_subnets
  security_groups = [var.public_sg]
  idle_timeout    = 400
  enable_http2    = true
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.lb_name}-tg-${substr(uuid(), 0, 3)}"
  port        = 5000
  protocol    = var.tg_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = var.elb_healthy_threshold
    unhealthy_threshold = var.elb_unhealthy_threshold
    timeout             = var.elb_timeout
    interval            = var.elb_interval
    path                = var.health_check_path
    port = 5000
    matcher = "200,304"
  }

  lifecycle {
    ignore_changes = [
      name
    ]
    create_before_destroy = true
  }
}



resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn

  }

}


