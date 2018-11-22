locals {
  platform_domain = "${var.platform_domain == "" ? "${aws_eip.master.public_ip}.nip.io" : var.platform_domain}"
  internal_domain = "master.${var.platform_name}.internal"
}

resource "aws_route53_zone" "private" {
  name   = "${var.platform_name}.internal"
  vpc_id = "${data.aws_vpc.platform.id}"

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned"
  )}"
}

resource "aws_route53_record" "master" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "master.${var.platform_name}.internal"
  type    = "A"

  alias {
    name                   = "${aws_elb.master_internal.dns_name}"
    zone_id                = "${aws_elb.master_internal.zone_id}"
    evaluate_target_health = false
  }
}
