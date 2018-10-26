data "template_file" "primed_ami_inventory" {
  template = "${file("${path.module}/resources/build-ami-inventory")}"

  vars {
    ansible_user              = "${local.bastion_ssh_user}"
    openshift_deployment_type = "${var.upstream ? "origin" : "openshift-enterprise"}"
    platform_name             = "${var.platform_name}"
  }
}

data "template_file" "primed_ami_provisioning_vars" {
  template = "${file("${path.module}/resources/build-ami-provisioning-vars.yml")}"

  vars {
    ansible_user                = "${local.bastion_ssh_user}"
    openshift_deployment_type   = "${var.upstream ? "origin" : "openshift-enterprise"}"
    platform_name               = "${var.platform_name}"
    platform_aws_region         = "${data.aws_region.current.name}"
    platform_aws_az             = "${data.aws_subnet.public.*.availability_zone[0]}"
    platform_vpc_cidr           = "${data.aws_vpc.platform.cidr_block}"
    platform_public_subnet_cidr = "${data.aws_subnet.public.*.cidr_block[0]}"
    platform_key_name           = "${aws_key_pair.platform.id}"
    platform_base_ami           = "${data.aws_ami.base.id}"
    security_group              = "${aws_security_group.primed_ami.name}"

    rhn_username            = "${var.rhn_username}"
    rhn_password            = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
  }
}

data "template_file" "primed_ami_builder" {
  template = "${file("${path.module}/resources/build-ami.sh")}"

  vars {
    platform_aws_region = "${data.aws_region.current.name}"
  }
}

resource "null_resource" "primed_ami" {
  provisioner "file" {
    content     = "${data.template_file.primed_ami_inventory.rendered}"
    destination = "~/primed-ami-inventory"
  }

  provisioner "file" {
    content     = "${data.template_file.primed_ami_provisioning_vars.rendered}"
    destination = "~/primed-ami-provisioning-vars.yml"
  }

  provisioner "file" {
    content     = "${data.template_file.primed_ami_builder.rendered}"
    destination = "~/primed-ami-build.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo /root/ensure-provisioned.sh",
      "sh ~/primed-ami-build.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "${local.bastion_ssh_user}"
    private_key = "${data.tls_public_key.platform.private_key_pem}"
    host        = "${aws_eip.bastion.public_ip}"
  }

  triggers {
    inventory         = "${data.template_file.primed_ami_inventory.rendered}"
    privisioning_vars = "${data.template_file.primed_ami_provisioning_vars.rendered}"
  }

  depends_on = ["aws_autoscaling_group.bastion"]
}

data "aws_ami" "primed" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["openshift-gi-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  depends_on = ["null_resource.primed_ami"]
}
