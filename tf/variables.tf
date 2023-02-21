variable "env" {}
variable "aws_region" {
  default = "us-east-1"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "access_ip" {
  type = string
}
variable "app" {
  default = "test"
}

# variable "ecr_url" {
#   description = "Docker Image Repository"
#   type        = string
#   default     = "965543693501.dkr.ecr.us-east-1.amazonaws.com"
# }

variable "image_tag" {
  default = "latest"
}

variable "container_name" {
  default = "web-app"
  
}