data "template_file" "template_inventory" {
  template = "${file("${path.module}/resources/template-inventory.yml")}"

  vars {
    platform_name                  = "${var.platform_name}"
    ansible_user                   = "${(var.upstream) ? "centos" : "ec2-user"}"
    platform_domain                = "${local.platform_domain}"
    openshift_deployment_type      = "${(var.upstream) ? "origin" : "openshift-enterprise"}"
    openshift_major_version        = "${var.openshift_major_version}"
    openshift_repos_enable_testing = "${(var.upstream) ? "true" : "false"}"
    openshift_cluster_admin_users  = "[${join(",", formatlist("\"%s\"", var.openshift_cluster_admin_users))}]"
  }

  depends_on = ["aws_autoscaling_group.master"]
}

data "aws_region" "current" {}

data "template_file" "installer_template" {
  template = "${file("${path.module}/resources/openshift-install.sh")}"

  vars {
    platform_name           = "${var.platform_name}"
    platform_aws_region     = "${data.aws_region.current.name}"
    openshift_major_version = "${var.openshift_major_version}"
    rhn_username            = "${var.rhn_username}"
    rhn_password            = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
  }
}
