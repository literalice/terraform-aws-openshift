module "openshift_platform" {
  source = "../.."

  platform_name             = "${var.platform_name}"
  key_pair_private_key_path = "${var.key_pair_private_key_path}"

  operator_cidrs      = "${var.operator_cidrs}"
  public_access_cidrs = "${var.public_access_cidrs}"

  compute_node_count    = "${var.compute_node_count}"
  infra_node_count      = "${var.infra_node_count}"
  master_count          = "${var.master_count}"
  master_instance_type  = "${var.master_instance_type}"
  compute_instance_type = "${var.compute_instance_type}"
  infra_instance_type   = "${var.infra_instance_type}"

  rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
  rhn_username            = "${var.rhn_username}"
  rhn_password            = "${var.rhn_password}"

  platform_default_subdomain = "${var.platform_default_subdomain}"
}
