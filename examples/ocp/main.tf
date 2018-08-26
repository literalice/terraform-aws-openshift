module "openshift_platform" {
  source = "../.."

  platform_name             = "${var.platform_name}"
  key_pair_private_key_path = "${var.key_pair_private_key_path}"

  operator_cidrs = "${var.operator_cidrs}"
  public_cidrs   = "${var.public_cidrs}"

  master_count          = "${var.master_count}"
  master_instance_type  = "${var.master_instance_type}"
  compute_node_count    = "${var.compute_node_count}"
  compute_instance_type = "${var.compute_instance_type}"

  rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
  rhn_username            = "${var.rhn_username}"
  rhn_password            = "${var.rhn_password}"

  platform_domain                     = "${var.platform_domain}"
  platform_domain_administrator_email = "${var.platform_domain_administrator_email}"

  bastion_image_id = "${var.image_id}"
  node_image_id    = "${var.image_id}"
}
