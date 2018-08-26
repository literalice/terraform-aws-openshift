module "domain" {
  source = "./modules/domain"

  platform_name   = "${var.platform_name}"
  platform_vpc_id = "${module.network.platform_vpc_id}"

  platform_domain                     = "${var.platform_domain}"
  platform_domain_administrator_email = "${var.platform_domain_administrator_email}"

  master_endpoints = ["${module.infrastructure.master_endpoints}"]

  router_endpoints = ["${module.infrastructure.master_endpoints}"]

  bastion_endpoint    = "${module.infrastructure.bastion_endpoint}"
  bastion_ssh_user    = "${module.infrastructure.bastion_ssh_user}"
  bastion_private_key = "${module.infrastructure.platform_private_key}"
}
