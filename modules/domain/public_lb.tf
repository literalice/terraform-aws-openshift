data "aws_lb" "public" {
  arn = "${var.public_lb_arn}"
}
