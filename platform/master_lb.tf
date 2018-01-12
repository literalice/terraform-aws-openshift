# TODO Network LoadBalancer cannot be received packets from target instances
resource "aws_elb" "master" {
  name = "${var.platform_name}-master-lb"
  internal = true
  subnets = ["${data.aws_subnet.private.*.id}"]
  security_groups = [
    "${aws_security_group.node.id}"
  ]

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned"
  )}"

  listener {
    instance_port = 8443
    instance_protocol = "tcp"
    lb_port = 8443
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "TCP:22"
    interval = 30
  }
}
