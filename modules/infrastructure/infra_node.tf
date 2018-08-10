resource "aws_iam_instance_profile" "infra_node" {
  name = "${var.platform_name}-infra-node-profile"
  role = "${aws_iam_role.infra_node.name}"
}

resource "aws_launch_configuration" "infra_node" {
  name_prefix   = "${var.platform_name}-infra-node-"
  image_id      = "${local.openshift_image_id}"
  instance_type = "${var.infra_instance_type}"

  security_groups = [
    "${aws_security_group.node.id}",
    "${aws_security_group.infra_node.id}",
    "${aws_security_group.platform_public.id}",
  ]

  key_name             = "${aws_key_pair.platform.id}"
  iam_instance_profile = "${aws_iam_instance_profile.infra_node.name}"

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }
}

resource "aws_autoscaling_group" "infra_node" {
  vpc_zone_identifier       = ["${data.aws_subnet.node.*.id}"]
  name                      = "${var.platform_name}-infra-node"
  max_size                  = "${var.infra_node_count}"
  min_size                  = "${var.infra_node_count}"
  desired_capacity          = "${var.infra_node_count}"
  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.infra_node.name}"

  target_group_arns = [
    "${aws_lb_target_group.platform_public_insecure.arn}",
    "${aws_lb_target_group.platform_public.arn}",
  ]

  tag {
    key                 = "kubernetes.io/cluster/${var.platform_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.platform_name}-infra-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "node"
    propagate_at_launch = true
  }

  tag {
    key                 = "openshift_node_group_name"
    value               = "node-config-infra"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}
