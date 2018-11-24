data "aws_route53_zone" "public" {
  name = "${var.platform_domain}."
}
