resource "aws_vpc" "platform" {
  cidr_block                       = "${var.platform_cidr}"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}"
  )}"
}
