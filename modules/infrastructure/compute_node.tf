resource "aws_iam_instance_profile" "compute_node" {
  name = "${var.platform_name}-compute-profile"
  role = "${aws_iam_role.compute_node.name}"
}

resource "aws_launch_configuration" "compute_node" {
  name_prefix   = "${var.platform_name}-compute-node-"
  image_id      = "${local.node_image_id}"
  instance_type = "${var.compute_node_instance_type}"

  spot_price = "${var.compute_node_spot_price}"

  security_groups = [
    "${aws_security_group.node.id}",
  ]

  associate_public_ip_address = true

  key_name             = "${aws_key_pair.platform.id}"
  iam_instance_profile = "${aws_iam_instance_profile.compute_node.name}"

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }
}

resource "aws_autoscaling_group" "compute_node" {
  vpc_zone_identifier       = ["${data.aws_subnet.node.*.id}"]
  name                      = "${var.platform_name}-compute-node"
  max_size                  = "${var.compute_node_count}"
  min_size                  = "${var.compute_node_count}"
  desired_capacity          = "${var.compute_node_count}"
  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.compute_node.name}"

  tag {
    key                 = "kubernetes.io/cluster/${var.platform_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.platform_name}-compute-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "node"
    propagate_at_launch = true
  }

  tag {
    key                 = "openshift_node_group_name"
    value               = "node-config-compute"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}
