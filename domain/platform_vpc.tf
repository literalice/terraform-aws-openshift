data "aws_vpc" "platform" {
  id  = "${var.platform_vpc_id}"
}
