variable "vpc_name" {}
variable "vpc_cidr" {}
variable "public_cidrs" {
  type = list(any)
}

variable "private_cidrs" {
  type = list(any)
}

variable "pub_sn_count" {}
variable "priv_sn_count" {}
variable "max_subnets" {}
variable "access_ip" {
  type = string
}

variable "security_groups" {}