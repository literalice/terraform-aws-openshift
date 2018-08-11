resource "aws_iam_instance_profile" "master" {
  name = "${var.platform_name}-master-profile"
  role = "${aws_iam_role.master.name}"
}

resource "aws_instance" "master" {
  count = "${var.master_spot_price == "" ? 1 : 0}"

  ami           = "${local.node_image_id}"
  instance_type = "${var.master_instance_type}"

  associate_public_ip_address = true

  subnet_id = "${element(data.aws_subnet.node.*.id, 0)}"

  vpc_security_group_ids = [
    "${aws_security_group.node.id}",
    "${aws_security_group.master_public.id}",
  ]

  key_name = "${aws_key_pair.platform.id}"

  iam_instance_profile = "${aws_iam_instance_profile.master.name}"

  root_block_device {
    volume_size           = 100
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-master",
    "Role", "master,node",
    "openshift_node_group_name", "${local.master_node_group_name}",
    )}"
}

resource "aws_spot_instance_request" "master" {
  count = "${var.master_spot_price == "" ? 0 : 1}"

  spot_price           = "${var.master_spot_price}"
  wait_for_fulfillment = true
  spot_type            = "one-time"

  ami           = "${local.node_image_id}"
  instance_type = "${var.master_instance_type}"

  associate_public_ip_address = true

  subnet_id = "${element(data.aws_subnet.node.*.id, 0)}"

  vpc_security_group_ids = [
    "${aws_security_group.node.id}",
    "${aws_security_group.master_public.id}",
  ]

  key_name = "${aws_key_pair.platform.id}"

  iam_instance_profile = "${aws_iam_instance_profile.master.name}"

  root_block_device {
    volume_size           = 100
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-master",
    "Role", "master,node",
    "openshift_node_group_name", "${local.master_node_group_name}",
    )}"
}

data "aws_instance" "master" {
  instance_id = "${element(concat(aws_instance.master.*.id, aws_spot_instance_request.master.*.spot_instance_id), 0)}"
}
