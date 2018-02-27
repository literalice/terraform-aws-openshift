resource "aws_key_pair" "platform" {
    key_name   = "${var.platform_name}"
    public_key = "${var.key_pair_public_key}"
}
