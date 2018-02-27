data "aws_iam_policy_document" "bastion" {
  statement {
    actions = [
        "ssm:DescribeAssociation",
        "ssm:GetDeployablePatchSnapshotForInstance",
        "ssm:GetDocument",
        "ssm:GetManifest",
        "ssm:GetParameters",
        "ssm:ListAssociations",
        "ssm:ListInstanceAssociations",
        "ssm:PutInventory",
        "ssm:PutComplianceItems",
        "ssm:PutConfigurePackageResult",
        "ssm:UpdateAssociationStatus",
        "ssm:UpdateInstanceAssociationStatus",
        "ssm:UpdateInstanceInformation"
    ]
    effect = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
        "ec2messages:AcknowledgeMessage",
        "ec2messages:DeleteMessage",
        "ec2messages:FailMessage",
        "ec2messages:GetEndpoint",
        "ec2messages:GetMessages",
        "ec2messages:SendReply"
    ]
    effect = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
        "cloudwatch:PutMetricData"
    ]
    effect = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
        "ec2:Describe*"
    ]
    effect = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
        "ds:CreateComputer",
        "ds:DescribeDirectories"
    ]
    effect = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents"
    ]
    effect = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "bastion" {
    name = "${var.platform_name}-bastion-role"
    assume_role_policy = "${data.aws_iam_policy_document.ec2.json}"
}

resource "aws_iam_role_policy" "bastion" {
    name = "${var.platform_name}-bastion-policy"
    role = "${aws_iam_role.bastion.id}"
    policy = "${data.aws_iam_policy_document.bastion.json}"
}
