output "ec2_access_key" {
  sensitive = true
  value = module.ec2.access_key
}