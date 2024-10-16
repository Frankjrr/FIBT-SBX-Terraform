# main.tf

terraform {
  required_version = ">= 1.0.0"

 # (Optional) Configure the backend if you plan to use remote state
  backend "s3" {
    bucket = "teraform-work-testing"
    key    = "optimized-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

# Local values for derived configurations
locals {
  vpc_name    = "${var.tags["Project"]}-vpc"
  subnet_name = "${var.tags["Project"]}-public-subnet-"
}

# Create a new VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = local.vpc_name })
}

# Create a new Subnet for the above VPC
resource "aws_subnet" "dev_private_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = local.subnet_name })
}

resource "aws_default_route_table" "default-rtb" {
  default_route_table_id = aws_vpc.dev_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "dev-main-rtb"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.dev_private_subnet.id
  route_table_id = aws_default_route_table.default-rtb.id
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.dev_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name: "${local.vpc_name}-default-sg"
  }

}

resource "aws_key_pair" "ssh-key" {
  key_name = "id_rsa"
  public_key = file(var.public_key_location)
}


// getting latest aws instance id bases on filters
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

// creating the ec2
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.dev_private_subnet.id
  #availability_zone = var.avail_zone
  vpc_security_group_ids = [aws_default_security_group.default.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name
  #user_data = file("entry-script.sh")
  #user_data_replace_on_change = true


  tags = {
    Name: "${local.vpc_name}-server"
  }
}


