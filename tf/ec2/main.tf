data "aws_ami" "jump" {
  most_recent      = true
  name_regex       = "jump_server"
}

locals {
  instance_count = length(var.subnets)
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "jumpbox" {
  key_name   = "jumpbox"
  public_key = tls_private_key.this.public_key_openssh
}


# create a ec2 instance

resource "aws_instance" "this" {
  count = local.instance_count
  ami           = data.aws_ami.jump.id
  instance_type = "t2.micro"
  key_name      = "jumpbox"
  subnet_id     = var.subnets[count.index]
  vpc_security_group_ids = var.security_groups

  tags = {
    Name = "jump_server_${count.index}"
  }
}