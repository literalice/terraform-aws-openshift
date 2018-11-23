data "template_file" "master" {
  template = "${file("${path.module}/resources/master-init.yml")}"

  vars {
    platform_name = "${var.platform_name}"
  }
}
