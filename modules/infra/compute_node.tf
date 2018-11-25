resource "aws_launch_template" "compute_node" {
  name_prefix = "${var.platform_name}-compute-node-"

  block_device_mappings {
    device_name = "${local.base_image_root_device_name}"

    ebs {
      volume_size = 100
    }
  }

  image_id = "${local.base_image_id}"

  instance_market_options {
    market_type = "${var.use_spot ? "spot" : ""}"
  }

  instance_type = "${var.compute_node_instance_type}"

  iam_instance_profile {
    arn = "${aws_iam_instance_profile.compute_node.arn}"
  }

  key_name = "${aws_key_pair.platform.id}"

  tag_specifications {
    resource_type = "instance"

    tags = "${map(
      "kubernetes.io/cluster/${var.platform_name}", "owned",
      "Name", "${var.platform_name}-compute_node",
      "Role", "node",
      "openshift_node_group_name", "node-config-compute"
    )}"
  }

  vpc_security_group_ids = ["${aws_security_group.node.id}"]
}

resource "aws_autoscaling_group" "compute_node" {
  name                = "${var.platform_name}-compute"
  vpc_zone_identifier = ["${var.private_subnet_ids}"]
  desired_capacity    = "${var.compute_node_count}"
  max_size            = "${var.compute_node_count}"
  min_size            = "${var.compute_node_count}"

  # TODO workaround
  launch_template = {
    id      = "${aws_launch_template.compute_node.id}"
    version = "$$Latest"
  }
}
