resource "aws_iam_instance_profile" "compute_node" {
  name = "${var.platform_name}-compute-profile"
  role = "${aws_iam_role.compute_node.name}"
}

resource "aws_launch_configuration" "compute_node" {
  name_prefix   = "${var.platform_name}-compute-node-"
  image_id      = "${data.aws_ami.node.id}"
  instance_type = "m4.large"

  security_groups = [
    "${aws_security_group.node.id}",
  ]

  key_name             = "${aws_key_pair.platform.id}"
  user_data            = "${data.template_file.node_init.rendered}"
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
  vpc_zone_identifier       = ["${data.aws_subnet.private.*.id}"]
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

  timeouts {
    delete = "15m"
  }
}
