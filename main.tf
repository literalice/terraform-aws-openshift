resource "null_resource" "openshift" {
  provisioner "remote-exec" {
    inline = [
      "/etc/oc-install.sh",
    ]
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file(var.key_pair_private_key_path)}"
    host = "${data.aws_instance.bastion.public_ip}"
  }

  triggers = {
    bastion_instance_id = "${data.aws_instance.bastion.id}"
  }

  depends_on = ["module.network", "module.infrastructure", "module.domain"]
}
