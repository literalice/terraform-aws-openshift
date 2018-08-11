module "network" {
  source = "./modules/network"

  platform_name = "${var.platform_name}"
}
