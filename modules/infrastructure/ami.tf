data "aws_ami" "bastion" {
  owners      = ["${(var.upstream) ? "679593333241" : "309956199498"}"]
  most_recent = true

  filter {
    name   = "name"
    values = ["${(var.upstream) ? "CentOS Linux 7 x86_64 HVM EBS *" : "RHEL-7.5_HVM_GA-????????-x86_64-*-Access2-*"}"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "node" {
  owners      = ["${(var.upstream) ? "679593333241" : "309956199498"}"]
  most_recent = true

  filter {
    name   = "name"
    values = ["${(var.upstream) ? "CentOS Linux 7 x86_64 HVM EBS *" : "RHEL-7.5_HVM_GA-????????-x86_64-*-Access2-*"}"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
