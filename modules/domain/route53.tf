resource "aws_route53_zone" "public" {
  count = "${var.platform_domain == "" ? 0 : 1}"

  name = "${var.platform_domain}."

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned"
  )}"
}

resource "aws_route53_record" "master_public" {
  count = "${var.platform_domain == "" ? 0 : 1}"

  zone_id = "${aws_route53_zone.public.zone_id}"
  name    = "${var.platform_domain}"
  type    = "A"
  ttl     = 300
  records = ["${var.master_endpoints}"]
}

resource "aws_route53_record" "router_public" {
  count = "${var.platform_domain == "" ? 0 : 1}"

  zone_id = "${aws_route53_zone.public.zone_id}"
  name    = "*.${var.platform_domain}"
  type    = "A"
  ttl     = 300
  records = ["${var.router_endpoints}"]
}
