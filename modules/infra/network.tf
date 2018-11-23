data "aws_subnet" "public" {
  count = "${length(var.public_subnet_ids)}"
  id    = "${element(var.public_subnet_ids, count.index)}"
}

data "aws_subnet" "private" {
  count = "${length(var.private_subnet_ids)}"
  id    = "${element(var.private_subnet_ids, count.index)}"
}
