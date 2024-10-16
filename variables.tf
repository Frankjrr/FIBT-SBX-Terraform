# variables.tf

# AWS Configuration

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

# Subnet Configuration
variable "subnet_cidr" {
  description = "CIDR block for the subnet."
  type        = string
  default     = "10.0.1.0/20"
}

# Tags
variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default = {
    Environment = "development"
    Project     = "MyProject"
  }
}
variable "public_key_location" {}

variable "instance_type" {}
