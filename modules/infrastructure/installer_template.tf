data "template_file" "inventory_template" {
  template = "${file("${path.module}/resources/openshift-inventory.yml")}"

  vars {
    platform_name = "${var.platform_name}"
    master_public_dns_name = "${var.master_public_dns_name}"
    platform_default_subdomain = "${var.platform_default_subdomain}"
  }
}

data "aws_region" "current" {
}

data "template_file" "installer_template" {
  template = "${file("${path.module}/resources/openshift-install.sh")}"

  vars {
    platform_name = "${var.platform_name}"
    platform_aws_region = "${data.aws_region.current.name}"
  }
}
