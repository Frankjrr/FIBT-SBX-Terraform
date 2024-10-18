module "ec2_instance" {
    source  = "terraform-aws-modules/ec2-instance/aws"

    ami = var.ec2_config["ami_id"] != null ? var.ec2_config["ami_id"] : lookup(var.ami_map, var.ec2_config["ami_name"], "")
    name = var.ec2_config["instance_name"]
    instance_type          = var.ec2_config["instance_type"]
    key_name               = var.ec2_config["key_name"]
    vpc_security_group_ids = distinct(
      flatten([
        var.ec2_config["sg_id"] != null ? var.ec2_config["sg_id"] : [],
        contains(keys(var.ec2_config), "security_group_name") && var.ec2_config["security_group_name"] != null ? [
          for security_group_name in var.ec2_config["security_group_name"] :
          lookup(var.sg_ids, security_group_name, "")
        ] : []
      ])
    )
    # subnet_id              = lookup(local.combined_subnet_ids, var.ec2_config["subnet_id"], "")
    subnet_id = var.ec2_config["subnet_id"]
    associate_public_ip_address = var.ec2_config["associate_public_ip_address"]
    disable_api_stop = var.ec2_config["disable_api_stop"]
    disable_api_termination  = var.ec2_config["disable_api_termination"]
    iam_instance_profile = var.ec2_config["iam_instance_profile_create"] ? aws_iam_instance_profile.this[0].name : var.ec2_config["iam_instance_profile_name"]
    tags = var.ec2_config["tags"]
    volume_tags = var.ec2_config["volume_tags"]
    metadata_options = var.ec2_config["metadata_options"]
    root_block_device = var.ec2_config["root_block_device"] != null ? var.ec2_config["root_block_device"] : null
    ebs_block_device = var.ec2_config["ebs_block_device"] != null ? var.ec2_config["ebs_block_device"] : null
}