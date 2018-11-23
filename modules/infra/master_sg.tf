# FOR Master Public LB
resource "aws_security_group" "master_public" {
  name        = "${var.platform_name}-master-public"
  description = "Master public group for ${var.platform_name}"

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${var.operator_cidrs}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-master-public"
  )}"

  vpc_id = "${data.aws_vpc.platform.id}"
}

# FOR Master Node
resource "aws_security_group" "master" {
  name        = "${var.platform_name}-master"
  description = "Master group for ${var.platform_name}"

  # From Master Public LB
  ingress {
    from_port       = 8443
    to_port         = 8443
    protocol        = "tcp"
    security_groups = ["${aws_security_group.master_public.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-master"
  )}"

  vpc_id = "${data.aws_vpc.platform.id}"
}
