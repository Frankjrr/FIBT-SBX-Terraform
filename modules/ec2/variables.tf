variable "ec2_config" {
  type = object({
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
  })
}

variable "combined_subnet_ids" {
    type = any
}

variable "roles" {
    type = any
}

variable "ami_map" {
  type = any
}

variable "sg_ids" {
  type = any
}

variable "target_group_arn" {
  type = any
}