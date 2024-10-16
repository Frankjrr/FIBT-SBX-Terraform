# terraform.tfvars

vpc_cidr    = "10.0.0.0/16"
subnet_cidr = "10.0.0.0/24"

tags = {
  Environment = "development"
  Project     = "OptimizedVPC"
}
public_key_location = "C:/Users/hassan.tariq/.ssh/id_rsa.pub"

instance_type =  "t3.micro"

