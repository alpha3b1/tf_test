output "vpc_id" {
  value = aws_vpc.this_vpc.id
}

output "app_sg" {
  value = aws_security_group.sg["app"].id
}

output "ssh_sg" {
  value = aws_security_group.sg["ssh"].id
}

output "frontend_sg" {
  value = aws_security_group.sg["frontend_sg"].id
}

output "public_subnets" {
  value = aws_subnet.pub_subnet.*.id
}

output "private_subnets" {
  value = aws_subnet.priv_subnet.*.id
}