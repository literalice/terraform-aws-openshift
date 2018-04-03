data "template_file" "node_init" {
  template = "${(var.upstream) ? file("${path.module}/resources/origin-node-init.yml") : file("${path.module}/resources/node-init.yml")}"

  vars {
    rhn_username            = "${var.rhn_username}"
    rhn_password            = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
  }
}
