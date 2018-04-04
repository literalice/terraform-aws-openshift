resource "aws_lb" "master_public" {
  name                             = "${var.platform_name}-master-public-lb"
  internal                         = false
  subnets                          = ["${data.aws_subnet.public.*.id}"]
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned"
  )}"
}

resource "aws_lb_listener" "master_public" {
  load_balancer_arn = "${aws_lb.master_public.arn}"
  port              = "8443"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.master_public.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "master_public" {
  name                 = "${var.platform_name}-master-public"
  port                 = 8443
  protocol             = "TCP"
  vpc_id               = "${data.aws_vpc.platform.id}"
  deregistration_delay = 20
}

resource "aws_lb_listener" "master_public_insecure" {
  load_balancer_arn = "${aws_lb.master_public.arn}"
  port              = "80"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.master_public_insecure.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "master_public_insecure" {
  name                 = "${var.platform_name}-master-insecure"
  port                 = 80
  protocol             = "TCP"
  deregistration_delay = 20
  vpc_id               = "${data.aws_vpc.platform.id}"
}

data "dns_a_record_set" "master_public_lb" {
  host = "${aws_lb.master_public.dns_name}"
}
