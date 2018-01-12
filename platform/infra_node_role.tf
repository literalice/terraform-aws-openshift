data "aws_iam_policy_document" "infra_node" {
  statement {
    actions = [
        "ec2:*",
        "ec2:AttachVolume",
        "ssm:GetDocument",
        "ec2:DetachVolume",
        "elasticloadbalancing:*"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "infra_node" {
    name = "${var.platform_name}-infra-node-role"
    assume_role_policy = "${data.aws_iam_policy_document.ec2.json}"
}

resource "aws_iam_role_policy" "infra_node" {
    name = "${var.platform_name}-infra-node-policy"
    role = "${aws_iam_role.infra_node.id}"
    policy = "${data.aws_iam_policy_document.infra_node.json}"
}
