output "dynamodb_table_id" {
  value = aws_dynamodb_table.dynamo.id
}

output "cross_account_access_role_arn" {
  value = aws_iam_role.lambda_cross_account_access.arn
}