data "template_file" "bastion_init" {
  template = "${(var.upstream) ? file("${path.module}/resources/origin-bastion-init.yml") : file("${path.module}/resources/bastion-init.yml")}"

  vars {
    rhn_username = "${var.rhn_username}"
    rhn_password = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
    openshift_inventory = "${var.openshift_inventory == "" ?
      indent(6, data.template_file.inventory_template.rendered) :
      var.openshift_inventory}"
    openshift_install = "${indent(6, data.template_file.installer_template.rendered)}"
    openshift_major_version = "${var.openshift_major_version}"
  }
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.platform_name}-bastion-profile"
  role = "${aws_iam_role.bastion.name}"
}

resource "aws_instance" "bastion" {
  ami = "${data.aws_ami.bastion.id}"
  instance_type = "t2.micro"
  subnet_id = "${element(data.aws_subnet.public.*.id, 0)}"
  associate_public_ip_address = true
  key_name = "${aws_key_pair.platform.id}"

  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.bastion.name}"

  user_data = "${data.template_file.bastion_init.rendered}"

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-bastion",
    "Role", "bastion"
  )}"
}

resource "null_resource" "openshift_platform_key" {
  provisioner "file" {
    content = "${data.tls_public_key.platform.private_key_pem}"
    destination = "~/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 ~/.ssh/id_rsa",
    ]
  }

  connection {
    type = "ssh"
    user = "${(var.upstream) ? "centos" : "ec2-user"}"
    private_key = "${data.tls_public_key.platform.private_key_pem}"
    host = "${aws_instance.bastion.public_ip}"
  }

  triggers = {
    bastion_instance_id = "${aws_instance.bastion.id}"
  }

  depends_on = ["aws_instance.bastion"]
}
