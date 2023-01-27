resource "aws_dynamodb_table" "dynamo" {
  hash_key         = var.partition_key
  range_key        = var.sort_key
  name             = var.name
  stream_enabled   = var.stream_enabled
  stream_view_type = "NEW_AND_OLD_IMAGES"
  billing_mode     = var.billing_mode
  read_capacity    = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity   = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.key.arn
  }

  attribute {
    name = var.partition_key
    type = "N"
  }

  attribute {
    name = var.sort_key
    type = "N"
  }
}
