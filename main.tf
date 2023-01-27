provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = "us-east-1"
}

provider "aws" {
  alias   = "us_west_2"
  region  = "us-west-2"
  profile = "us-west-2"
}

data "aws_caller_identity" "us_east_1" {
  provider = aws.us_east_1
}

data "aws_caller_identity" "us_west_2" {
  provider = aws.us_west_2
}

locals {
  aws_account_us_east_1 = data.aws_caller_identity.us_east_1.account_id
  aws_account_us_west_2 = data.aws_caller_identity.us_west_2.account_id
}

module "dynamo-us-east-1" {
  source                        = "./modules/dynamo-stream"
  name                          = "dynamo-us-east-1"
  local_aws_account_id          = local.aws_account_us_east_1
  destination_aws_account_id    = local.aws_account_us_west_2
  destination_aws_region        = "us-west-2"
  destination_dynamodb_table_id = module.dynamo-us-west-2.dynamodb_table_id
  cross_account_access_role_arn = module.dynamo-us-west-2.cross_account_access_role_arn
  providers = {
    aws = aws.us_east_1
  }
}

module "dynamo-us-west-2" {
  source                        = "./modules/dynamo-stream"
  name                          = "dynamo-us-west-2"
  local_aws_account_id          = local.aws_account_us_west_2
  destination_aws_account_id    = local.aws_account_us_east_1
  destination_aws_region        = "us-east-1"
  destination_dynamodb_table_id = module.dynamo-us-east-1.dynamodb_table_id
  cross_account_access_role_arn = module.dynamo-us-east-1.cross_account_access_role_arn
  providers = {
    aws = aws.us_west_2
  }
}
