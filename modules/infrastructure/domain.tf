locals {
  platform_domain = "${var.platform_domain == "" ? "${data.aws_instance.master.public_ip}.nip.io" : var.platform_domain}"
}
