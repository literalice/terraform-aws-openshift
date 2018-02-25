resource "aws_route53_zone" "public" {
  name = "${var.platform_default_subdomain}."

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned"
  )}"
}

resource "aws_route53_record" "platform_public" {
  zone_id = "${aws_route53_zone.public.zone_id}"
  name = "*.${var.platform_default_subdomain}"
  type = "A"

  alias {
    name = "${data.aws_lb.platform_public.dns_name}"
    zone_id = "${data.aws_lb.platform_public.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "master_public" {
  zone_id = "${aws_route53_zone.public.zone_id}"
  name = "${var.master_public_dns_name}"
  type = "A"

  alias {
    name = "${data.aws_lb.master_public.dns_name}"
    zone_id = "${data.aws_lb.master_public.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "bastion_public" {
  zone_id = "${aws_route53_zone.public.zone_id}"
  name = "bastion.${var.platform_default_subdomain}"
  type = "A"
  ttl     = "30"
  records = ["${var.bastion_ip}"]
}
