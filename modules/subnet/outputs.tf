output "subnet-id" {
  value = aws_subnet.myapp-subnet1
}
output "default_route_table_id" {
  value = aws_vpc.myapp-vpc.default_route_table_id
}
output "vpc-id" {
  value = aws_vpc.myapp-vpc.id
}