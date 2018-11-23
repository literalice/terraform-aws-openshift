data "aws_ami" "commercial" {
  most_recent = true

  owners = ["309956199498"]

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
    values = ["RHEL-7.5_HVM_GA-????????-x86_64-*-Access2-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

data "aws_ami" "community" {
  most_recent = true

  owners = ["679593333241"]

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
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  base_image_id               = "${var.use_community ? data.aws_ami.community.image_id : data.aws_ami.commercial.image_id}"
  base_image_root_device_name = "${var.use_community ? data.aws_ami.community.root_device_name : data.aws_ami.commercial.root_device_name}"
}
