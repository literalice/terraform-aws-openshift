
locals {
  base_image_owners           = "${var.use_community ? "679593333241" : "309956199498"}"
  base_image_name             = "${var.use_community ? "CentOS Linux 7 x86_64 HVM EBS *" : "RHEL-7.5_HVM_GA-????????-x86_64-*-Access2-*"}"
  base_image_id               = "${var.use_specific_base_image ? var.specific_base_image_id : data.aws_ami.base_image.image_id}"
  base_image_root_device_name = "${var.use_specific_base_image ? var.specific_base_image_root_device_name : data.aws_ami.base_image.root_device_name}"
}

data "aws_ami" "base_image" {
  most_recent = true

  owners = ["${local.base_image_owners}"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["${local.base_image_name}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
