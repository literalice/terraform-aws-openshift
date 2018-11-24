module "openshift_domain" {
  source                              = "../../modules/domain"
  platform_name                       = "${var.platform_name}"
  platform_domain                     = "${var.platform_domain}"
  platform_domain_administrator_email = "${var.platform_domain_administrator_email}"
  public_lb_arn                       = "${var.public_lb_arn}"
}
