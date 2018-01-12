module "openshift_domain" {
  source = "../domain"

  platform_vpc_id = "${module.openshift_network.platform_vpc_id}"
  platform_name = "${var.platform_name}"
  platform_dns_name = "${var.platform_dns_name}"
  platform_private_dns_name = "${var.platform_private_dns_name}"
  bastion_ip = "${data.aws_instance.bastion.public_ip}"
  master_public_dns_name = "${var.master_public_dns_name}"
  master_public_lb_arn = "${module.openshift_platform.master_public_lb_arn}"
  master_dns_name = "${var.master_dns_name}"
  master_lb_name = "${module.openshift_platform.master_lb_name}"
  platform_public_lb_arn = "${module.openshift_platform.platform_public_lb_arn}"
}
