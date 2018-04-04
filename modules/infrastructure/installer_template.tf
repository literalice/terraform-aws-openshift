data "template_file" "inventory_template" {
  template = "${file("${path.module}/resources/openshift-inventory.yml")}"

  vars {
    platform_name                  = "${var.platform_name}"
    ansible_user                   = "${(var.upstream) ? "centos" : "cloud-user"}"
    master_public_dns_name         = "${var.master_public_dns_name}"
    platform_default_subdomain     = "${var.platform_default_subdomain}"
    openshift_deployment_type      = "${(var.upstream) ? "origin" : "openshift-enterprise"}"
    openshift_major_version        = "${var.openshift_major_version}"
    openshift_repos_enable_testing = "${(var.upstream) ? "true" : "false"}"
  }
}

data "aws_region" "current" {}

data "template_file" "installer_template" {
  template = "${file("${path.module}/resources/openshift-install.sh")}"

  vars {
    platform_name       = "${var.platform_name}"
    platform_aws_region = "${data.aws_region.current.name}"
  }
}
