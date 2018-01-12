resource "aws_security_group" "bastion" {
  name = "${var.platform_name}-bastion"
  description = "Bastion group for ${var.platform_name}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.operator_cidrs}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-bastion",
    "Role", "bastion"
  )}"

  vpc_id = "${data.aws_vpc.platform.id}"
}
