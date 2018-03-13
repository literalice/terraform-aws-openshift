resource "tls_private_key" "tmp" {
  # count = "${var.key_pair_private_key == "" ? 1 : 0}"
  algorithm = "ECDSA"
  ecdsa_curve = "P384"
}

data "tls_public_key" "platform" {
  private_key_pem = "${var.key_pair_private_key == "" ? tls_private_key.tmp.private_key_pem : var.key_pair_private_key}"
}

resource "aws_key_pair" "platform" {
    key_name   = "${var.platform_name}"
    public_key = "${data.tls_public_key.platform.public_key_openssh}"
}
