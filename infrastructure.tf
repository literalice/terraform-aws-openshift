module "infrastructure" {
  source = "./modules/infrastructure"

  platform_name = "${var.platform_name}"

  platform_vpc_id = "${module.network.platform_vpc_id}"
  public_subnet_ids = ["${module.network.public_subnet_ids}"]
  private_subnet_ids = ["${module.network.private_subnet_ids}"]

  operator_cidrs = ["${var.operator_cidrs}"]
  public_access_cidrs = ["${var.public_access_cidrs}"]

  master_public_dns_name = "master.${var.platform_default_subdomain}"
  platform_default_subdomain = "${var.platform_default_subdomain}"

  infra_node_count = "${var.infra_node_count}"
  master_count = "${var.master_count}"
  master_spot_price = "${var.master_spot_price}"

  key_pair_private_key = "${file(var.key_pair_private_key_path)}"

  upstream = "${var.upstream}"
  openshift_major_version = "${var.openshift_major_version}"
  openshift_image_tag = "${var.openshift_image_tag}"
  rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
  rhn_username = "${var.rhn_username}"
  rhn_password = "${var.rhn_password}"
}
