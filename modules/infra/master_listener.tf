resource "aws_lb_target_group" "master_public" {
  name                 = "${var.platform_name}-master-public"
  port                 = 8443
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

resource "aws_lb_listener" "master_public" {
  load_balancer_arn = "${aws_lb.public.arn}"
  port              = 8443
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.master_public.arn}"
    type             = "forward"
  }
}
