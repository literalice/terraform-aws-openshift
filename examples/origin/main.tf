module "openshift_platform" {
  source = "../.."

  upstream                   = true
  platform_name              = "${var.platform_name}"
  key_pair_private_key_path  = "${var.key_pair_private_key_path}"
  operator_cidrs             = "${var.operator_cidrs}"
  public_access_cidrs        = "${var.public_access_cidrs}"
  compute_node_count         = "${var.compute_node_count}"
  infra_node_count           = "${var.infra_node_count}"
  master_count               = "${var.master_count}"
  master_spot_price          = "${var.master_spot_price}"
  platform_default_subdomain = "${var.platform_default_subdomain}"
  openshift_image_tag        = "v3.9.0"
}
