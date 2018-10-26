resource "aws_security_group" "primed_ami" {
  name        = "${var.platform_name}-primed-ami"
  description = "Primed AMI builder for ${var.platform_name}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.bastion.public_ip}/32"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-primed-ami",
    "Role", "amibuilder",
    )}"

  vpc_id = "${data.aws_vpc.platform.id}"
}
