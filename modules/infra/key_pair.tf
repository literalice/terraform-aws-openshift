resource "tls_private_key" "platform" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

data "tls_public_key" "platform" {
  private_key_pem = "${tls_private_key.platform.private_key_pem}"
}

resource "aws_key_pair" "platform" {
  key_name   = "${var.platform_name}"
  public_key = "${data.tls_public_key.platform.public_key_openssh}"
}
