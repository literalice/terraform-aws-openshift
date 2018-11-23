data "template_file" "bastion_init" {
  template = "${file("${path.module}/resources/bastion-init.yml")}"

  vars {
    platform_name = "${var.platform_name}"
  }
}
