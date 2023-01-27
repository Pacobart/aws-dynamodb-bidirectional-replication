resource "aws_kms_key" "key" {
  description         = var.name
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.key_policy.json
}

data "aws_iam_policy_document" "key_policy" {
  statement {
    sid    = "KeyOwnership"
    effect = "Allow"
    actions = [
      "kms:*",
    ]
    principals {
      type = "AWS"
      identifiers = [
        var.local_aws_account_id
      ]
    }

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "Allow KMS Use"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    principals {
      type = "AWS"
      identifiers = [
        var.destination_aws_account_id
      ]
    }

    resources = [
      "*"
    ]
  }
}
