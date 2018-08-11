module "domain" {
  source = "./modules/domain"

  platform_name   = "${var.platform_name}"
  platform_vpc_id = "${module.network.platform_vpc_id}"

  platform_domain = "${var.platform_domain}"

  master_endpoints = ["${module.infrastructure.master_endpoints}"]
}
