data "template_file" "bastion_repos" {
  template = "${file("${path.module}/resources/bastion-repos.sh")}"

  vars {
    platform_name           = "${var.platform_name}"
    rhn_username            = "${var.rhn_username}"
    rhn_password            = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
    openshift_major_version = "${var.openshift_major_version}"
  }
}

resource "null_resource" "bastion_repos" {
  provisioner "file" {
    content     = "${data.template_file.bastion_repos.rendered}"
    destination = "~/bastion-repos.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/bastion-repos.sh",
      "export USE_COMMUNITY=${var.use_community ? "true" : ""}",
      "sh ~/bastion-repos.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "${var.bastion_ssh_user}"
    private_key = "${var.platform_private_key}"
    host        = "${var.bastion_endpoint}"
  }

  triggers {
    script = "${data.template_file.bastion_repos.rendered}"
  }
}
