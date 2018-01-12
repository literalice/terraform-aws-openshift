module "openshift_network" {
  source = "../network"

  platform_name = "${var.platform_name}"
  operator_cidrs = "[${var.operator_cidrs}]"
  public_access_cidrs = "[${var.public_access_cidrs}]"
}
