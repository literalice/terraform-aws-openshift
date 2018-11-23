resource "aws_eip" "bastion" {
  vpc = true

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-bastion",
    "Role", "bastion"
  )}"
}
