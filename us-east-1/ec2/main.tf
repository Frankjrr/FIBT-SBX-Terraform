data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.vpc_state_config.bucket
    key    = var.vpc_state_config.key
    region = var.vpc_state_config.region
    profile = var.vpc_state_config.profile
  }
}
 data "terraform_remote_state" "security_group" {
  backend = "s3"
  config = {
    bucket = var.security_groups_state_config.bucket
    key    = var.security_groups_state_config.key
    region = var.security_groups_state_config.region
    profile = var.security_groups_state_config.profile
  }
}

locals {
    //target_group_arn = data.terraform_remote_state.load_balancer.outputs.target_group_arns
    sg_ids = data.terraform_remote_state.security_group.outputs.security_group_ids
    //private_app_subnet_ids = data.terraform_remote_state.vpc.outputs.subnet_ids["Application"]["private_application"]
    //private_management_subnet_ids = data.terraform_remote_state.vpc.outputs.subnet_ids["Application"]["private_management"]
    //combined_subnet_ids = concat(local.private_app_subnet_ids, local.private_management_subnet_ids)
    //roles = data.terraform_remote_state.roles.outputs.role_details
    //ami_ids = data.aws_ami_ids.lvm_images.ids
    # Create a map to ensure the correct order of names and IDs
#     ami_map = {
#         for i, name in var.ami_names : name => local.ami_ids[i]
#     }
  # #     logging_empty = {for bucket, bucket_detail in var.bucket_details : bucket => merge(bucket_detail, {logging_config = {}})
  # #  if bucket_detail["logging_config"]["target_bucket"] == null}
  #   target_group_details_empty = {for ec2, instance_details in var.ec2_config : ec2 => merge(instance_details, {target_group_details = []})
  #   if instance_details["target_group_details"]["target_group_name"] == null}
  #   ec2_details = merge(var.ec2_config, local.target_group_details_empty)
}
module "ec2" {
    source = "../../modules/ec2"
    for_each = var.ec2_config
    ec2_config = var.ec2_config[each.key]
    //combined_subnet_ids = local.combined_subnet_ids
#     ami_map = local.ami_map
#     roles = local.roles
    sg_ids = local.sg_ids
    //target_group_arn = local.target_group_arn
  ami_map = ""
  combined_subnet_ids = ""
  roles = ""
  target_group_arn = ""
}