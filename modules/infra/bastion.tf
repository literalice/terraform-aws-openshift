locals {
  bastion_ssh_user = "${(var.use_community) ? "centos" : "ec2-user"}"
}

resource "aws_instance" "bastion" {
  ami = "${local.base_image_id}"

  instance_type = "m4.large"

  key_name = "${aws_key_pair.platform.id}"

  associate_public_ip_address = true
  subnet_id                   = "${element(var.public_subnet_ids, 0)}"
  user_data                   = "${base64encode(data.template_file.bastion_init.rendered)}"

  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  tags = "${map(
      "kubernetes.io/cluster/${var.platform_name}", "owned",
      "Name", "${var.platform_name}-bastion",
      "Role", "bastion"
    )}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 32
  }
}
