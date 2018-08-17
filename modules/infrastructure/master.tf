resource "aws_iam_instance_profile" "master" {
  name = "${var.platform_name}-master-profile"
  role = "${aws_iam_role.master.name}"
}

resource "aws_launch_configuration" "master" {
  name_prefix   = "${var.platform_name}-master-"
  image_id      = "${local.node_image_id}"
  instance_type = "${var.master_instance_type}"

  spot_price = "${var.master_spot_price}"

  associate_public_ip_address = true

  security_groups = [
    "${aws_security_group.node.id}",
    "${aws_security_group.master_public.id}",
  ]

  key_name             = "${aws_key_pair.platform.id}"
  iam_instance_profile = "${aws_iam_instance_profile.master.name}"

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }
}

resource "aws_autoscaling_group" "master" {
  vpc_zone_identifier       = ["${data.aws_subnet.node.*.id}"]
  name                      = "${var.platform_name}-master"
  max_size                  = "${var.master_count}"
  min_size                  = "${var.master_count}"
  desired_capacity          = "${var.master_count}"
  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.master.name}"

  tag {
    key                 = "kubernetes.io/cluster/${var.platform_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.platform_name}-master"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "master,node"
    propagate_at_launch = true
  }

  tag {
    key                 = "openshift_node_group_name"
    value               = "${local.master_node_group_name}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}

data "aws_instances" "master" {
  instance_tags {
    Name = "${var.platform_name}-master"
  }

  instance_state_names = ["running"]
  depends_on           = ["aws_autoscaling_group.master"]
}

data "aws_instance" "master" {
  instance_id = "${element(data.aws_instances.master.ids, 0)}"
}
