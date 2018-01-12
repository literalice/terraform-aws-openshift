# Endpoint for Internet access

resource "aws_lb" "platform_public" {
  name = "${var.platform_name}-public-lb"
  internal = false
  security_groups = ["${aws_security_group.platform_public.id}"]
  subnets = ["${data.aws_subnet.public.*.id}"]

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned"
  )}"
}

resource "aws_lb_listener" "platform_public_insecure" {
  load_balancer_arn = "${aws_lb.platform_public.arn}"
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.platform_public_insecure.arn}"
    type = "forward"
  }
}

resource "aws_lb_target_group" "platform_public_insecure" {
  name = "${var.platform_name}-public-insecure"
  port = 80
  protocol = "HTTP"
  deregistration_delay = 20
  vpc_id = "${data.aws_vpc.platform.id}"
}

data "aws_acm_certificate" "platform_public" {
  domain   = "*.${var.platform_default_subdomain}"
  statuses = ["ISSUED"]
}

resource "aws_lb_listener" "platform_public" {
  load_balancer_arn = "${aws_lb.platform_public.arn}"
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${data.aws_acm_certificate.platform_public.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.platform_public_insecure.arn}"
    type = "forward"
  }
}
