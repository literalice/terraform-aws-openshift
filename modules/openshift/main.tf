data "template_file" "deploy_cluster" {
  template = "${file("${path.module}/resources/deploy-cluster.sh")}"

  vars {
    platform_name           = "${var.platform_name}"
    platform_aws_region     = "${data.aws_region.current.name}"
    openshift_major_version = "${var.openshift_major_version}"
  }
}

resource "null_resource" "main" {
  provisioner "file" {
    content     = "${data.template_file.deploy_cluster.rendered}"
    destination = "~/deploy-cluster.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/deploy-cluster.sh",
      "sh ~/deploy-cluster.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "${var.bastion_ssh_user}"
    private_key = "${var.platform_private_key}"
    host        = "${var.bastion_endpoint}"
  }

  triggers {
    inventory = "${data.template_file.template_inventory.rendered}"
    installer = "${data.template_file.deploy_cluster.rendered}"
  }

  depends_on = ["null_resource.bastion_config", "null_resource.template_inventory"]
}
