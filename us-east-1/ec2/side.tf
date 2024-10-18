terraform {
  backend "s3" {
    bucket = "teraform-work-testing"
    key    = "optimized-vpc/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47"
    }
  }
}

# provider "aws" {
#   region    = var.provider_details["region"]
#   profile   = var.provider_details["profile"]
# }
#
# variable "provider_details" {
#   type = object({
#     region = string
#     profile = optional(string)
#   })
# }

# variable "ami_names" {
#   description = "List of AMI names to search for."
#   type        = list(string)
# }

variable "ec2_config" {
  type = map(object({
    ami_name               = optional(string)
    ami_id               = optional(string)
    sg_id                = optional(list(string))
    instance_name          = optional(string)
    instance_type          = optional(string)
    subnet_id             = optional(string)
    security_group_name = optional(list(string))
    associate_public_ip_address   = optional(bool)
    key_name               = optional(string)
    disable_api_stop = optional(bool)
    disable_api_termination  = optional(bool)
    target_group_details          = optional(list(object({
      target_group_name = optional(string)
      port              = optional(number)
      target_type       = optional(string)           # "instance" or "ip"
      ip_addresses      = optional(list(string)) # Only required if target_type is "ip"
    })))
    iam_instance_profile_create = optional(bool)
    iam_instance_profile_name     = optional(string)
    iam_instance_profile_role           = optional(string)
    tags              = optional(map(string))
    volume_tags       = optional(map(string))
    user_data           = optional(string)
    metadata_options  = optional(map(string))
    root_block_device = optional(list(map(string)))
    ebs_block_device  = optional(list(map(string)))
  }))
}

variable "vpc_state_config" {
    type = map
}

variable "security_groups_state_config" {
    type = map
}

# variable "roles_state_config" {
#     type = map
# }
#
# variable "load_balancer_state_config" {
#     type = map
# }

# output "ec2_ids" {
#   value = {for instance_key, instance_value in module.ec2 : instance_key => instance_value.ec2_ids}
# }