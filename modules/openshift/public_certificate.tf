resource "null_resource" "public_certificate" {
  provisioner "file" {
    content     = "${var.public_certificate_pem}"
    destination = "~/public_certificate.pem"
  }

  provisioner "file" {
    content     = "${var.public_certificate_key}"
    destination = "~/public_certificate.key"
  }

  provisioner "file" {
    content     = "${var.public_certificate_intermediate_pem}"
    destination = "~/public_certificate_intermediate.pem"
  }

  connection {
    type        = "ssh"
    user        = "${var.bastion_ssh_user}"
    private_key = "${var.platform_private_key}"
    host        = "${var.bastion_endpoint}"
  }
}
