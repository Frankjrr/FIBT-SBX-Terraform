

// -------------variable block-------------------------
terraform {

 # (Optional) Configure the backend if you plan to use remote state
  backend "s3" {
    bucket = "teraform-work-testing"
    key    = "optimized-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}


module "myapp-subnet" {
  source = "./modules/subnet"


  avail_zone             = var.avail_zone
  default_route_table_id = module.myapp-subnet.default_route_table_id
  env_prefix             = var.env_prefix
  subnet_cidr_block      = var.subnet_cidr_block
  vpc_id                 = module.myapp-subnet.vpc-id
  vpc_cidr_block         = var.vpc_cidr_block
}


module "myapp-webserver" {
  source = "./modules/webserver"
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  instance_type = var.instance_type
  public_key_location = var.public_key_location
  subnet_cidr_block = var.subnet_cidr_block
  vpc_id = module.myapp-subnet.vpc-id
  subnetid = module.myapp-subnet.subnet-id.id
}



