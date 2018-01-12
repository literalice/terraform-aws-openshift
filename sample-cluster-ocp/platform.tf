module "openshift_platform" {
  source = "../platform"

  platform_name = "${var.platform_name}"
  platform_vpc_id = "${module.openshift_network.platform_vpc_id}"
  key_pair_public_key = "${var.key_pair_public_key}"
  key_pair_private_key = "${file(var.key_pair_private_key_path)}"

  public_subnet_ids = ["${module.openshift_network.public_subnet_ids}"]
  private_subnet_ids = ["${module.openshift_network.private_subnet_ids}"]

  operator_cidrs = ["${var.operator_cidrs}"]
  public_access_cidrs = ["${var.public_access_cidrs}"]

  rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
  rhn_username = "${var.rhn_username}"
  rhn_password = "${var.rhn_password}"

  master_dns_name = "${var.master_dns_name}"
  master_public_dns_name = "${var.master_public_dns_name}"
  platform_default_subdomain = "${var.platform_dns_name}"

  infra_node_count = "${var.infra_node_count}"
  master_count = "${var.master_count}"
}
