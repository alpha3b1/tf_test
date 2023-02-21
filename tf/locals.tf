locals {
  security_groups = {
    frontend_sg = {
      name        = "frontend_sg"
      description = "Frontend load balancer sg"
      ingress = {
        https = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    },
    app = {
      name        = "app_sg"
      description = "Security group for app services"
      ingress = {
        https = {
          from        = 5000
          to          = 5000
          protocol    = "tcp"
          cidr_blocks = ["10.10.0.0/16"]
        }
      }
    },
    ssh = {
      name        = "jumpserver_sg"
      description = "Security group for jump servers"
      ingress = {
        https = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
  }

  account_id = data.aws_caller_identity.current.account_id
}