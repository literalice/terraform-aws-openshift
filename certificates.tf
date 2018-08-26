resource "null_resource" "certificate_files" {
  count = "${var.platform_domain == "" ? 0 : 1}"

  provisioner "file" {
    content     = "${module.domain.certificate_pem}"
    destination = "~/platform_cert.pem"
  }

  provisioner "file" {
    content     = "${module.domain.certificate_key}"
    destination = "~/platform_cert.key"
  }

  provisioner "file" {
    content     = "${module.domain.certificate_intermediate_pem}"
    destination = "~/platform_intermediate.pem"
  }

  connection {
    type        = "ssh"
    user        = "${module.infrastructure.bastion_ssh_user}"
    private_key = "${module.infrastructure.platform_private_key}"
    host        = "${data.aws_instance.bastion.public_ip}"
  }

  depends_on = ["module.infrastructure", "module.domain"]
}
