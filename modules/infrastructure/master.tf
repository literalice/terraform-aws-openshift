resource "aws_eip" "master" {
  count = "${var.master_count}"

  vpc = true

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-master",
    "Role", "master"
  )}"
}

# Create a internal load balancer
resource "aws_elb" "master_internal" {
  name     = "${var.platform_name}-master-internal"
  subnets  = ["${data.aws_subnet.private.*.id}"]
  internal = true

  security_groups = [
    "${aws_security_group.node.id}",
  ]

  listener {
    instance_port     = 8443
    instance_protocol = "tcp"
    lb_port           = 8443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:22"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-master")}"
}

data "template_file" "master_init" {
  template = "${file("${path.module}/resources/master-init.yml")}"

  vars {
    platform_name = "${var.platform_name}"
  }
}

resource "aws_iam_instance_profile" "master" {
  name = "${var.platform_name}-master-profile"
  role = "${aws_iam_role.master.name}"
}

resource "aws_launch_configuration" "master" {
  name_prefix   = "${var.platform_name}-master-"
  image_id      = "${data.aws_ami.primed.image_id}"
  instance_type = "${var.master_instance_type}"

  spot_price = "${var.master_spot_price}"

  security_groups = [
    "${aws_security_group.node.id}",
    "${aws_security_group.master_public.id}",
    "${aws_security_group.platform_public.id}",
  ]

  associate_public_ip_address = true

  key_name             = "${aws_key_pair.platform.id}"
  iam_instance_profile = "${aws_iam_instance_profile.master.name}"

  user_data = "${data.template_file.master_init.rendered}"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["image_id"]
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }
}

resource "aws_autoscaling_group" "master" {
  vpc_zone_identifier       = ["${data.aws_subnet.private.*.id}"]
  name                      = "${var.platform_name}-master"
  max_size                  = "${var.master_count}"
  min_size                  = "${var.master_count}"
  desired_capacity          = "${var.master_count}"
  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.master.name}"

  load_balancers = ["${aws_elb.master_internal.name}"]

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

  lifecycle {
    create_before_destroy = true
  }
}
