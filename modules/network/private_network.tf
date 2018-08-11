# Private subnet: for instances / internal lb
resource "aws_subnet" "private" {
  count = "${length(var.private_subnet_cidrs)}"
  vpc_id = "${aws_vpc.platform.id}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block = "${element(var.private_subnet_cidrs, count.index)}"

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-private-${count.index}"
  )}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.platform.id}"
  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-private-rt"
  )}"
}

resource "aws_route" "private_internet" {
  route_table_id = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.public_gw.id}"
  depends_on = ["aws_route_table.private"]
}

resource "aws_route_table_association" "private" {
  count = "${length(var.private_subnet_cidrs)}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}
