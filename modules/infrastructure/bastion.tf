locals {
  bastion_ssh_user = "${(var.upstream) ? "centos" : "ec2-user"}"
}

data "template_file" "bastion_init" {
  template = "${(var.upstream) ? file("${path.module}/resources/origin-bastion-init.yml") : file("${path.module}/resources/bastion-init.yml")}"

  vars {
    rhn_username            = "${var.rhn_username}"
    rhn_password            = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"

    bastion_ssh_user = "${local.bastion_ssh_user}"

    openshift_major_version = "${var.openshift_major_version}"
    template_inventory      = "${base64encode(data.template_file.template_inventory.rendered)}"
    oc_install              = "${base64encode(data.template_file.installer_template.rendered)}"
    platform_id_rsa         = "${base64encode(data.tls_public_key.platform.private_key_pem)}"
  }
}

output "templateinventory" {
  value = "${data.template_file.bastion_init.rendered}"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.platform_name}-bastion-profile"
  role = "${aws_iam_role.bastion.name}"
}

resource "aws_launch_configuration" "bastion" {
  name_prefix   = "${var.platform_name}-bastion-"
  image_id      = "${local.node_image_id}"
  instance_type = "${var.bastion_instance_type}"

  spot_price = "${var.bastion_spot_price}"

  security_groups = ["${aws_security_group.bastion.id}"]

  associate_public_ip_address = true

  key_name             = "${aws_key_pair.platform.id}"
  iam_instance_profile = "${aws_iam_instance_profile.bastion.name}"

  user_data = "${data.template_file.bastion_init.rendered}"

  spot_price = "${var.bastion_spot_price}"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["user_data"]
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  vpc_zone_identifier       = ["${data.aws_subnet.public.*.id}"]
  name                      = "${var.platform_name}-bastion"
  max_size                  = "1"
  min_size                  = "1"
  desired_capacity          = "1"
  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.bastion.name}"

  tag {
    key                 = "Name"
    value               = "${var.platform_name}-bastion"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}

data "aws_instances" "bastion" {
  instance_tags {
    Name = "${var.platform_name}-bastion"
  }

  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.platform.id}"]
  }

  instance_state_names = ["running"]
  depends_on           = ["aws_autoscaling_group.bastion"]
}
