module "openshift" {
  source = "../../modules/openshift"

  platform_name           = "${var.platform_name}"
  bastion_ssh_user        = "${var.bastion_ssh_user}"
  bastion_endpoint        = "${var.bastion_endpoint}"
  platform_private_key    = "${var.platform_private_key}"
  rhn_username            = "${var.rhn_username}"
  rhn_password            = "${var.rhn_password}"
  rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
  master_domain           = "${var.master_domain}"
  platform_domain         = "${var.platform_domain}"
}
