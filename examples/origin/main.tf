module "openshift_platform" {
  source = "../.."

  upstream = true

  platform_name             = "${var.platform_name}"
  key_pair_private_key_path = "${var.key_pair_private_key_path}"

  operator_cidrs = "${var.operator_cidrs}"
  public_cidrs   = "${var.public_cidrs}"

  master_count          = "${var.master_count}"
  master_instance_type  = "${var.master_instance_type}"
  compute_node_count    = "${var.compute_node_count}"
  compute_instance_type = "${var.compute_instance_type}"

  platform_domain                     = "${var.platform_domain}"
  platform_domain_administrator_email = "${var.platform_domain_administrator_email}"

  bastion_image_id = "${var.image_id}"
  node_image_id    = "${var.image_id}"
}
