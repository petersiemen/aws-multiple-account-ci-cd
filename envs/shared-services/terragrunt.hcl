remote_state {
  backend = "s3"
  generate = {
    path = "generated-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "homepage-shared-services-terraform-state-new"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
    dynamodb_table = "shared-services-terraform-lock"
  }
}

generate "provider" {
  path = "generated-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

provider "aws" {
  region  = "eu-central-1"
  profile = "homepage-master"
  assume_role {
    role_arn  = "arn:aws:iam::391559760545:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
  profile = "homepage-master"
  assume_role {
    role_arn  = "arn:aws:iam::391559760545:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias = "eu-west-1"
  region = "eu-west-1"
  profile = "homepage-master"
  assume_role {
    role_arn  = "arn:aws:iam::391559760545:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  region  = "eu-central-1"
  alias = "homepage-development"
  profile = "homepage-master"
  assume_role {
    role_arn  = "arn:aws:iam::387558367268:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  region  = "eu-central-1"
  alias = "homepage-production"
  profile = "homepage-master"
  assume_role {
    role_arn  = "arn:aws:iam::098961484923:role/OrganizationAccountAccessRole"
  }
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
      TF_VAR_organization = "petersiemen"
      TF_VAR_aws_region = "eu-central-1"
      TF_VAR_domain = "petersiemen.net"

      TF_VAR_shared_services_account_id = "391559760545"
      TF_VAR_shared_services_account_email = "peter.siemen+shared-services@gmail.com"

      TF_VAR_development_account_id = "387558367268"
      TF_VAR_development_account_email = "peter.siemen+development@gmail.com"

      TF_VAR_production_account_id = "098961484923"
      TF_VAR_production_account_email = "peter.siemen+production@gmail.com"
    }
  }

}
