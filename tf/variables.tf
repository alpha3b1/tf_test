variable "env" {}
variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "access_ip" {
  type = string
}
variable "app" {
  default = "test"
}


variable "image_tag" {
  default = "latest"
}

variable "container_name" {
  default = "web-app"
  
}