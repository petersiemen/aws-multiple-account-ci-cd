remote_state {
  backend = "s3"
  generate = {
    path = "generated-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "${var.master_account_state_bucket_name}"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
    dynamodb_table = "terraform-lock"
  }
}

generate "provider" {
  path = "generated-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region  = "eu-central-1"
}

provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  region  = "eu-central-1"
  alias = "identity"
  assume_role {
    role_arn = "arn:aws:iam::${var.identity_account_id}:role/IdentityAccountAccessRole"
  }
}

EOF
}
//
//terraform {
//  extra_arguments "common_vars" {
//    commands = [
//      "plan",
//      "apply",
//      "destroy",
//      "refresh"]
//
//  }
//
//}
