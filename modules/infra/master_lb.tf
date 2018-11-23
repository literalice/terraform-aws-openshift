resource "aws_elb" "master" {
  name     = "${var.platform_name}-master"
  subnets  = ["${data.aws_subnet.private.*.id}"]
  internal = true

  security_groups = ["${aws_security_group.node.id}"]

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
    target              = "TCP:8443"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 180
  connection_draining         = true
  connection_draining_timeout = 180

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-master")}"
}
