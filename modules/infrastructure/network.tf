data "aws_vpc" "platform" {
  id = "${var.platform_vpc_id}"
}

data "aws_subnet" "public" {
  count = "${length(var.public_subnet_ids)}"
  id    = "${element(var.public_subnet_ids, count.index)}"
}

data "aws_subnet" "private" {
  count = "${length(var.private_subnet_ids)}"
  id    = "${element(var.private_subnet_ids, count.index)}"
}

# for ebs pv provisioning, node instances must residence in all subnets.

locals {
  node_scaling_subnet_ids = "${split(",", var.compute_node_count < length(var.private_subnet_ids) ? join(",", slice(var.private_subnet_ids, 0, var.compute_node_count)) : join(",", var.private_subnet_ids))}"
}

output subnets {
  value = "${local.node_scaling_subnet_ids}"
}

data "aws_subnet" "node" {
  count = "${length(local.node_scaling_subnet_ids)}"
  id    = "${element(local.node_scaling_subnet_ids, count.index)}"
}
