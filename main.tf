module "openshift_network" {
  source        = "modules/network"
  platform_name = "${var.platform_name}"
}

module "openshift_infra" {
  source = "modules/infra"

  platform_name = "${var.platform_name}"

  platform_vpc_id    = "${var.platform_vpc_id}"
  public_subnet_ids  = ["${var.public_subnet_ids}"]
  private_subnet_ids = ["${var.private_subnet_ids}"]

  operator_cidrs = ["0.0.0.0/0"]

  use_spot = true

  master_count = "${var.master_count}"
}

module "openshift_domain" {
  source                              = "modules/domain"
  platform_name                       = "${var.platform_name}"
  platform_domain                     = "${var.platform_domain}"
  platform_domain_administrator_email = "${var.platform_domain_administrator_email}"
  public_lb_arn                       = "${var.public_lb_arn}"
}

module "openshift" {
  source = "modules/openshift"

  platform_name           = "${var.platform_name}"
  bastion_ssh_user        = "${var.bastion_ssh_user}"
  bastion_endpoint        = "${var.bastion_endpoint}"
  platform_private_key    = "${var.platform_private_key}"
  rhn_username            = "${var.rhn_username}"
  rhn_password            = "${var.rhn_password}"
  rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
  master_domain           = "${var.master_domain}"
  platform_domain         = "${var.platform_domain}"
}
