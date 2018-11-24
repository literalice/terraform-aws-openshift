data "aws_iam_policy_document" "compute_node" {
  statement {
    actions = [
      "ec2:*",
      "ec2:AttachVolume",
      "ssm:GetDocument",
      "ec2:DetachVolume",
      "elasticloadbalancing:*",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "compute_node" {
  name               = "${var.platform_name}-compute-node-role"
  assume_role_policy = "${data.aws_iam_policy_document.ec2.json}"
}

resource "aws_iam_role_policy" "compute_node" {
  name   = "${var.platform_name}-compute-node-policy"
  role   = "${aws_iam_role.compute_node.id}"
  policy = "${data.aws_iam_policy_document.compute_node.json}"
}

resource "aws_iam_instance_profile" "compute_node" {
  name = "${var.platform_name}-compute-profile"
  role = "${aws_iam_role.compute_node.name}"
}
