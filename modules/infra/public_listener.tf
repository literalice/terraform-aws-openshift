# http
resource "aws_lb_target_group" "http" {
  name                 = "${var.platform_name}-http"
  port                 = 80
  protocol             = "TCP"
  vpc_id               = "${data.aws_vpc.platform.id}"
  deregistration_delay = 180

  health_check {
    interval            = 30
    port                = "traffic-port"
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.public.arn}"
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.http.arn}"
    type             = "forward"
  }
}

# https
resource "aws_lb_target_group" "https" {
  name                 = "${var.platform_name}-https"
  port                 = 443
  protocol             = "TCP"
  vpc_id               = "${data.aws_vpc.platform.id}"
  deregistration_delay = 180

  health_check {
    interval            = 30
    port                = "traffic-port"
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = "${aws_lb.public.arn}"
  port              = 443
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.https.arn}"
    type             = "forward"
  }
}
