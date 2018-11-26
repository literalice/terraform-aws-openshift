data "template_file" "bastion_config_playbook" {
  template = "${file("${path.module}/resources/bastion-config-playbook.yaml")}"

  vars {
    openshift_major_version = "${var.openshift_major_version}"
  }
}

data "template_file" "bastion_config" {
  template = "${file("${path.module}/resources/bastion-config.sh")}"
}

resource "null_resource" "bastion_config" {
  provisioner "file" {
    content     = "${data.template_file.bastion_config_playbook.rendered}"
    destination = "~/bastion-config-playbook.yaml"
  }

  provisioner "file" {
    content     = "${data.template_file.bastion_config.rendered}"
    destination = "~/bastion-config.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/bastion-config.sh",
      "export USE_COMMUNITY=${var.use_community ? "true" : ""}",
      "sh  ~/bastion-config.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "${var.bastion_ssh_user}"
    private_key = "${var.platform_private_key}"
    host        = "${var.bastion_endpoint}"
  }

  triggers {
    playbook = "${data.template_file.bastion_config_playbook.rendered}"
  }

  depends_on = ["null_resource.bastion_repos"]
}
