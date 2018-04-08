resource "null_resource" "openshift" {
  provisioner "remote-exec" {
    inline = [
      "sh ~/oc-install.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "${module.infrastructure.bastion_ssh_user}"
    private_key = "${module.infrastructure.platform_private_key}"
    host        = "${data.aws_instance.bastion.public_ip}"
  }

  triggers = {
    bastion_instance_id = "${data.aws_instance.bastion.id}"
  }

  depends_on = ["module.network", "module.infrastructure", "module.domain"]
}

resource "null_resource" "openshift_operations" {
  provisioner "remote-exec" {
    inline = [
      "ansible-playbook -i inventory.yml ~/playbooks/openshift-policies/config.yml",
    ]
  }

  connection {
    type        = "ssh"
    user        = "${module.infrastructure.bastion_ssh_user}"
    private_key = "${module.infrastructure.platform_private_key}"
    host        = "${data.aws_instance.bastion.public_ip}"
  }

  triggers = {
    bastion_instance_id = "${data.aws_instance.bastion.id}"
  }

  depends_on = ["null_resource.openshift"]
}
