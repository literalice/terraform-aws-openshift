# Endpoint for Internet access

resource "aws_lb" "platform_public" {
  name               = "${var.platform_name}-public-lb"
  internal           = false
  subnets            = ["${data.aws_subnet.public.*.id}"]
  load_balancer_type = "network"

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned"
  )}"
}

resource "aws_lb_listener" "platform_public_insecure" {
  load_balancer_arn = "${aws_lb.platform_public.arn}"
  port              = "80"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.platform_public_insecure.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "platform_public_insecure" {
  name                 = "${var.platform_name}-public-insecure"
  port                 = 80
  protocol             = "TCP"
  deregistration_delay = 20
  vpc_id               = "${data.aws_vpc.platform.id}"
}

resource "aws_lb_listener" "platform_public" {
  load_balancer_arn = "${aws_lb.platform_public.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.platform_public.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "platform_public" {
  name                 = "${var.platform_name}-public"
  port                 = 443
  protocol             = "TCP"
  deregistration_delay = 20
  vpc_id               = "${data.aws_vpc.platform.id}"
}
