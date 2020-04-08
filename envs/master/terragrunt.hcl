locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

remote_state {
  backend = "s3"
  generate = {
    path = "generated-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "homepage-master-terraform-state"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = local.common.inputs.aws_region
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

EOF
}


terraform {
  extra_arguments "common_vars" {
    commands = [
      "plan",
      "apply",
      "destroy",
      "refresh",
      "import"]


    env_vars = {
      TF_VAR_organization = local.common.inputs.organization
      TF_VAR_aws_region = local.common.inputs.aws_region
      TF_VAR_domain = local.common.inputs.domain

      TF_VAR_shared_services_account_id = local.common.inputs.shared_services_account_id
      TF_VAR_shared_services_account_email = local.common.inputs.shared_services_account_email

      TF_VAR_development_account_id = local.common.inputs.development_account_id
      TF_VAR_development_account_email = local.common.inputs.development_account_email

      TF_VAR_production_account_id = local.common.inputs.production_account_id
      TF_VAR_production_account_email = local.common.inputs.production_account_email
    }
  }

}
