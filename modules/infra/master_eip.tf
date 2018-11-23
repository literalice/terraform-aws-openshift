resource "aws_eip" "master" {
  count = "${var.master_count}"

  vpc = true

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-master",
    "Role", "master"
  )}"
}
