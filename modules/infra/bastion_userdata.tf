data "template_file" "bastion_init" {
  template = "${file("${path.module}/resources/bastion-init.yml")}"

  vars {
    platform_name    = "${var.platform_name}"
    bastion_ssh_user = "${local.bastion_ssh_user}"
    platform_id_rsa  = "${base64encode(data.tls_public_key.platform.private_key_pem)}"
  }
}
