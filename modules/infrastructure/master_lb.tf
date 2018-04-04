# TODO Network LoadBalancer cannot be received packets from target instances
resource "aws_elb" "master" {
  name     = "${var.platform_name}-master-lb"
  internal = true
  subnets  = ["${data.aws_subnet.private.*.id}"]

  security_groups = [
    "${aws_security_group.node.id}",
  ]

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned"
  )}"

  listener {
    instance_port     = 8443
    instance_protocol = "tcp"
    lb_port           = 8443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:22"
    interval            = 30
  }
}

resource "aws_route53_zone" "private" {
  name   = "${var.platform_name}.internal"
  vpc_id = "${data.aws_vpc.platform.id}"

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned"
  )}"
}

resource "aws_route53_record" "master" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "master.${var.platform_name}.internal"
  type    = "A"

  alias {
    name                   = "${aws_elb.master.dns_name}"
    zone_id                = "${aws_elb.master.zone_id}"
    evaluate_target_health = false
  }
}
