resource "aws_lb" "public" {
  name               = "${var.platform_name}-public"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${data.aws_subnet.public.*.id}"]

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-public"
  )}"
}
