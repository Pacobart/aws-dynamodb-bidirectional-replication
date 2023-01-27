# dynamodb variables
variable "name" {
  type        = string
  description = "name for table and related resources"
}

variable "stream_enabled" {
  type        = bool
  description = "enable stream and lambda creation"
  default     = true
}

variable "partition_key" {
  type        = string
  description = "hash key for table"
  default     = "partition_key"
}

variable "sort_key" {
  type        = string
  description = "hash key for table"
  default     = "sort_key"
}

variable "billing_mode" {
  type        = string
  description = "PAY_PER_REQUEST or PROVISIONED"
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  type        = number
  description = "read capacity for table if billing_mode=PROVISIONED"
  default     = 40
}

variable "write_capacity" {
  type        = number
  description = "write capacity for table if billing_mode=PROVISIONED"
  default     = 40
}

variable "local_aws_account_id" {
  type        = number
  description = "local aws account id. used for kms key ownership"
}

variable "destination_aws_account_id" {
  type        = number
  description = "destination aws account id. used for kms key usage"
}

variable "destination_aws_region" {
  type        = string
  description = "destination aws account region"
}

variable "destination_dynamodb_table_id" {
  type        = string
  description = "dynamodb table id to push stream events to"
}

# cross account variables
variable "cross_account_access_role_arn" {
  type        = string
  description = "iam role arn to give access to"
}