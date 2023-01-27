## iam for cross-acount access
resource "aws_iam_role" "lambda_cross_account_access" {
  #name_prefix = "dynamo-lambda-cross-account-"
  name = "dynamo-lambda-cross-account"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.destination_aws_account_id}:role/dynamo-lambda-execution"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "lambda_dynamo" {
  statement {
    sid = "dynamodb"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem"
    ]

    resources = [
      aws_dynamodb_table.dynamo.arn
    ]
  }

  statement {
    sid = "kms"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [
      aws_kms_key.key.arn
    ]
  }
}

resource "aws_iam_role_policy" "lambda_dynamo" {
  name   = "dynamo-lambda-access"
  role   = aws_iam_role.lambda_cross_account_access.name
  policy = data.aws_iam_policy_document.lambda_dynamo.json
}