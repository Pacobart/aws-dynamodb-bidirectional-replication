resource "aws_lambda_function" "lambda" {
  filename         = "${path.root}/lambda_function.zip"
  function_name    = var.name
  role             = aws_iam_role.lambda.arn
  handler          = "main.handler"
  source_code_hash = filebase64sha256("${path.root}/lambda_function.zip")

  runtime = "python3.9"

  environment {
    variables = {
      DESTINATION_DYNAMODB_TABLE_ID = var.destination_dynamodb_table_id
      DESTINATION_DYNAMODB_REGION   = var.destination_aws_region
      DESTINATION_IAM_ROLE_ARN      = var.cross_account_access_role_arn
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda,
  ]
}

resource "aws_lambda_event_source_mapping" "dynamodb" {
  event_source_arn  = aws_dynamodb_table.dynamo.stream_arn
  function_name     = aws_lambda_function.lambda.arn
  starting_position = "LATEST"
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = 7
}

resource "aws_iam_role" "lambda" {
  #name_prefix = "dynamo-lambda-execution-"
  name = "dynamo-lambda-execution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda" {
  name       = "dynamolambda"
  roles      = [aws_iam_role.lambda.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
}

data "aws_iam_policy_document" "kms" {
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

resource "aws_iam_role_policy" "kms" {
  name   = "kms"
  role   = aws_iam_role.lambda.name
  policy = data.aws_iam_policy_document.kms.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      var.cross_account_access_role_arn
    ]
  }
}

resource "aws_iam_role_policy" "lambda_assume_role" {
  name   = "assume-role-in-destination-account"
  role   = aws_iam_role.lambda.name
  policy = data.aws_iam_policy_document.lambda_assume_role.json
}