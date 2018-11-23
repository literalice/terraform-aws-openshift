module "openshift_infra" {
  source = "../../modules/infra"

  platform_name = "${var.platform_name}"

  platform_vpc_id    = "${var.platform_vpc_id}"
  public_subnet_ids  = ["${var.public_subnet_ids}"]
  private_subnet_ids = ["${var.private_subnet_ids}"]

  operator_cidrs = ["0.0.0.0/0"]

  use_spot = true

  master_count = "${var.master_count}"
}
