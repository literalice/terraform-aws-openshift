data "template_file" "node_config_playbook" {
  template = "${file("${path.module}/resources/node-config-playbook.yaml")}"

  vars {
    openshift_major_version = "${var.openshift_major_version}"
    rhn_username            = "${var.rhn_username}"
    rhn_password            = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
  }
}

data "template_file" "node_config" {
  template = "${file("${path.module}/resources/node-config.sh")}"

  vars {
    platform_name       = "${var.platform_name}"
    platform_aws_region = "${data.aws_region.current.name}"
  }
}

resource "null_resource" "node_config" {
  provisioner "file" {
    content     = "${data.template_file.node_config_playbook.rendered}"
    destination = "~/node-config-playbook.yaml"
  }

  provisioner "file" {
    content     = "${data.template_file.node_config.rendered}"
    destination = "~/node-config.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/node-config.sh",
      "sh ~/node-config.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "${var.bastion_ssh_user}"
    private_key = "${var.platform_private_key}"
    host        = "${var.bastion_endpoint}"
  }

  triggers {
    inventory = "${data.template_file.node_config_playbook.rendered}"
  }

  depends_on = ["null_resource.bastion_config", "null_resource.template_inventory"]
}
