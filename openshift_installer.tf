data "template_file" "template_inventory" {
  template = "${file("${path.module}/resources/template-inventory.yml")}"

  vars {
    platform_name                  = "${var.platform_name}"
    ansible_user                   = "${module.infrastructure.bastion_ssh_user}"
    rhn_username                   = "${var.rhn_username}"
    rhn_password                   = "${var.rhn_password}"
    rh_subscription_pool_id        = "${var.rh_subscription_pool_id}"
    platform_domain                = "${module.infrastructure.platform_domain}"
    openshift_deployment_type      = "${var.upstream ? "origin" : "openshift-enterprise"}"
    openshift_major_version        = "${var.openshift_major_version}"
    openshift_repos_enable_testing = "${var.upstream ? "true" : "false"}"
    named_certificate              = "${var.platform_domain == "" ? false : true}"
  }
}

data "template_file" "installer_template" {
  template = "${file("${path.module}/resources/openshift-install.sh")}"

  vars {
    platform_name           = "${var.platform_name}"
    platform_aws_region     = "${data.aws_region.current.name}"
    openshift_major_version = "${var.openshift_major_version}"
  }
}

resource "null_resource" "openshift_installer" {
  provisioner "file" {
    content     = "${data.template_file.template_inventory.rendered}"
    destination = "~/template-inventory.yml"
  }

  provisioner "file" {
    content     = "${data.template_file.installer_template.rendered}"
    destination = "~/oc-install.sh"
  }

  connection {
    type        = "ssh"
    user        = "${module.infrastructure.bastion_ssh_user}"
    private_key = "${module.infrastructure.platform_private_key}"
    host        = "${module.infrastructure.bastion_endpoint}"
  }

  triggers {
    inventory = "${data.template_file.template_inventory.rendered}"
    installer = "${data.template_file.installer_template.rendered}"
  }

  depends_on = ["module.infrastructure"]
}
