data "aws_lb" "platform_public" {
  arn  = "${var.platform_public_lb_arn}"
}
