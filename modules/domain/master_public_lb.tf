data "aws_lb" "master_public" {
  arn  = "${var.master_public_lb_arn}"
}
