data "template_file" "bastion_init" {
  template = "${(var.upstream) ? file("${path.module}/resources/origin-bastion-init.yml") : file("${path.module}/resources/bastion-init.yml")}"

  vars {
    rhn_username            = "${var.rhn_username}"
    rhn_password            = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"

    openshift_major_version = "${var.openshift_major_version}"
  }
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.platform_name}-bastion-profile"
  role = "${aws_iam_role.bastion.name}"
}

locals {
  bastion_ssh_user = "${(var.upstream) ? "centos" : "ec2-user"}"
}

resource "aws_instance" "bastion" {
  ami                         = "${local.bastion_image_id}"
  instance_type               = "m4.large"
  subnet_id                   = "${element(data.aws_subnet.public.*.id, 0)}"
  associate_public_ip_address = true
  key_name                    = "${aws_key_pair.platform.id}"

  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.bastion.name}"

  user_data = "${data.template_file.bastion_init.rendered}"

  tags = "${map(
    "Name", "${var.platform_name}-bastion",
    "Role", "bastion"
  )}"
}

resource "null_resource" "openshift_platform_key" {
  provisioner "file" {
    content     = "${data.tls_public_key.platform.private_key_pem}"
    destination = "~/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 ~/.ssh/id_rsa",
    ]
  }

  connection {
    type        = "ssh"
    user        = "${local.bastion_ssh_user}"
    private_key = "${data.tls_public_key.platform.private_key_pem}"
    host        = "${aws_instance.bastion.public_ip}"
  }

  triggers = {
    bastion_instance_id = "${aws_instance.bastion.id}"
  }

  depends_on = ["aws_instance.bastion"]
}

resource "null_resource" "openshift_additional_playbooks" {
  provisioner "file" {
    source      = "${path.module}/resources/playbooks"
    destination = "~"
  }

  connection {
    type        = "ssh"
    user        = "${local.bastion_ssh_user}"
    private_key = "${data.tls_public_key.platform.private_key_pem}"
    host        = "${aws_instance.bastion.public_ip}"
  }

  triggers = {
    bastion_instance_id = "${aws_instance.bastion.id}"
  }

  depends_on = ["aws_instance.bastion"]
}

locals {
  openshift_template_inventory = "${var.openshift_inventory == "" ? data.template_file.inventory_template.rendered : var.openshift_inventory}"
}

resource "null_resource" "openshift_installer" {
  provisioner "file" {
    content     = "${local.openshift_template_inventory}"
    destination = "~/template-inventory.yml"
  }

  provisioner "file" {
    content     = "${data.template_file.installer_template.rendered}"
    destination = "~/oc-install.sh"
  }

  connection {
    type        = "ssh"
    user        = "${local.bastion_ssh_user}"
    private_key = "${data.tls_public_key.platform.private_key_pem}"
    host        = "${aws_instance.bastion.public_ip}"
  }

  triggers = {
    bastion_instance_id          = "${aws_instance.bastion.id}"
    openshift_template_inventory = "${local.openshift_template_inventory}"
    installer_template           = "${data.template_file.installer_template.rendered}"
  }

  depends_on = ["aws_instance.bastion"]
}

resource "null_resource" "openshift_oc_inventory_util" {
  provisioner "remote-exec" {
    inline = [
      "sudo curl -L -o /usr/local/bin/ocinventory https://github.com/literalice/openshift-inventory-utils/releases/download/v0.1/ocinventory_unix",
      "sudo chmod +x /usr/local/bin/ocinventory",
    ]
  }

  connection {
    type        = "ssh"
    user        = "${local.bastion_ssh_user}"
    private_key = "${data.tls_public_key.platform.private_key_pem}"
    host        = "${aws_instance.bastion.public_ip}"
  }

  triggers = {
    bastion_instance_id = "${aws_instance.bastion.id}"
  }

  depends_on = ["aws_instance.bastion"]
}
