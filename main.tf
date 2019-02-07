module "network" {
  source        = "modules/network"
  platform_name = "${var.platform_name}"
}

module "infra" {
  source = "modules/infra"

  platform_name = "${var.platform_name}"
  use_community = "${var.use_community}"
  use_specific_base_image = "${var.use_specific_base_image}"
  specific_base_image_id = "${var.specific_base_image_id}"
  specific_base_image_root_device_name = "${var.specific_base_image_root_device_name}"

  platform_vpc_id    = "${module.network.platform_vpc_id}"
  public_subnet_ids  = ["${module.network.public_subnet_ids}"]
  private_subnet_ids = ["${module.network.private_subnet_ids}"]

  operator_cidrs = ["${var.operator_cidrs}"]
  public_cidrs   = ["${var.public_cidrs}"]

  use_spot = "${var.use_spot}"

  master_count               = "${var.master_count}"
  master_instance_type       = "${var.master_instance_type}"
  compute_node_count         = "${var.compute_node_count}"
  compute_node_instance_type = "${var.compute_node_instance_type}"
}

module "domain" {
  source = "modules/domain"

  platform_name                       = "${var.platform_name}"
  platform_domain                     = "${var.platform_domain}"
  platform_domain_administrator_email = "${var.platform_domain_administrator_email}"
  public_lb_arn                       = "${module.infra.public_lb_arn}"
}

module "openshift" {
  source = "modules/openshift"

  platform_name = "${var.platform_name}"
  use_community = "${var.use_community}"

  bastion_ssh_user        = "${module.infra.bastion_ssh_user}"
  bastion_endpoint        = "${module.infra.bastion_endpoint}"
  platform_private_key    = "${module.infra.platform_private_key}"
  rhn_username            = "${var.rhn_username}"
  rhn_password            = "${var.rhn_password}"
  rh_subscription_pool_id = "${var.rh_subscription_pool_id}"

  master_domain                       = "${module.infra.master_domain}"
  platform_domain                     = "${var.platform_domain}"
  public_certificate_pem              = "${module.domain.public_certificate_pem}"
  public_certificate_key              = "${module.domain.public_certificate_key}"
  public_certificate_intermediate_pem = "${module.domain.public_certificate_intermediate_pem}"

  identity_providers         = "${var.identity_providers}"

  google_client_id           = "${var.google_client_id}"
  google_client_secret       = "${var.google_client_secret}"
  google_client_domain       = "${var.google_client_domain}"
}
