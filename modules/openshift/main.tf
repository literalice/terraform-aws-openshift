data "template_file" "deploy_cluster" {
  template = "${file("${path.module}/resources/deploy-cluster.sh")}"

  vars {
    platform_name                 = "${var.platform_name}"
    platform_aws_region           = "${data.aws_region.current.name}"
    bastion_aws_access_key_id     = "${var.bastion_aws_access_key_id}"
    bastion_aws_secret_access_key = "${var.bastion_aws_secret_access_key}"
    openshift_major_version       = "${var.openshift_major_version}"
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
      "tmux new-session -d -s deploycluster ~/deploy-cluster.sh",
      "sleep 1",                                                  # https://stackoverflow.com/questions/36207752/how-can-i-start-a-remote-service-using-terraform-provisioning
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

  depends_on = [
    "null_resource.node_config",
    "null_resource.public_certificate",
    "null_resource.template_inventory",
    "null_resource.openshift_applier",
  ]
}
