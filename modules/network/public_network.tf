# Public subnet: for router LB

locals {
  public_subnet_count = "${length(data.aws_availability_zones.available.names)}"
}

resource "aws_subnet" "public" {
  count                   = "${local.public_subnet_count}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  vpc_id                  = "${aws_vpc.platform.id}"
  cidr_block              = "${cidrsubnet(aws_vpc.platform.cidr_block, ceil(log(local.private_subnet_count + local.public_subnet_count, 2)), local.private_subnet_count + count.index)}"
  map_public_ip_on_launch = true

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-public-${count.index}"
  )}"
}

# Public access to the router
resource "aws_internet_gateway" "public_gw" {
  vpc_id = "${aws_vpc.platform.id}"

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-public-gw"
  )}"
}

# Public route table: attach Internet gw for internet access.

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.platform.id}"

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-public-rt"
  )}"
}

resource "aws_route" "public_internet" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.public_gw.id}"
  depends_on             = ["aws_route_table.public"]
}

resource "aws_route_table_association" "public" {
  count          = "${local.public_subnet_count}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
