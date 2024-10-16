# outputs.tf

output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.dev_vpc.id
}

output "subnet_id" {
  description = "The ID of the subnet."
  value       = aws_subnet.dev_private_subnet.id
}

output "ec2-public_ip" {
  value = aws_instance.myapp-server.public_ip
}