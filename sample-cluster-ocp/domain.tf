module "openshift_domain" {
  source = "../domain"

  platform_name = "${var.platform_name}"
  platform_vpc_id = "${module.openshift_network.platform_vpc_id}"

  bastion_ip = "${data.aws_instance.bastion.public_ip}"

  platform_default_subdomain = "${var.platform_default_subdomain}"
  platform_public_lb_arn = "${module.openshift_platform.platform_public_lb_arn}"

  master_public_dns_name = "${var.master_public_dns_name}"
  master_public_lb_arn = "${module.openshift_platform.master_public_lb_arn}"
  master_private_dns_name = "${var.master_private_dns_name}"
  master_private_lb_name = "${module.openshift_platform.master_lb_name}"
}
