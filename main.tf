resource "null_resource" "openshift_check" {
  provisioner "remote-exec" {
    inline = [
      "export ANSIBLE_HOST_KEY_CHECKING=False",
      "export AWS_REGION=${data.aws_region.current.name}",
      "ocinventory -cluster '${var.platform_name}' -inventory ~/template-inventory.yml > ~/inventory.yml",
      "cat ~/inventory.yml",
      "ansible all -i ~/inventory.yml -m ping",
    ]
  }

  connection {
    type        = "ssh"
    user        = "${module.infrastructure.bastion_ssh_user}"
    private_key = "${module.infrastructure.platform_private_key}"
    host        = "${data.aws_instance.bastion.public_ip}"
  }

  depends_on = ["null_resource.openshift_installer"]
}

resource "null_resource" "openshift" {
  provisioner "remote-exec" {
    inline = [
      "export UPSTREAM=${var.upstream ? "true" : ""}",
      "sh ~/oc-install.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "${module.infrastructure.bastion_ssh_user}"
    private_key = "${module.infrastructure.platform_private_key}"
    host        = "${data.aws_instance.bastion.public_ip}"
  }

  triggers {
    openshift_installer = "${null_resource.openshift_installer.id}"
  }

  depends_on = ["null_resource.openshift_installer"]
}

resource "null_resource" "openshift_admin" {
  provisioner "remote-exec" {
    inline = [
      "export ANSIBLE_HOST_KEY_CHECKING=False",
      "ansible 'masters[0]' -i ~/inventory.yml -a 'oc adm policy add-cluster-role-to-user cluster-admin ${join(" ", var.openshift_cluster_admin_users)}'",
    ]
  }

  connection {
    type        = "ssh"
    user        = "${module.infrastructure.bastion_ssh_user}"
    private_key = "${module.infrastructure.platform_private_key}"
    host        = "${data.aws_instance.bastion.public_ip}"
  }

  depends_on = ["null_resource.openshift"]
}
