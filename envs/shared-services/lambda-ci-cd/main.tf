variable "organization" {}
variable "shared_services_account_id" {}
variable "development_account_id" {}
variable "development_account_email" {}
variable "production_account_id" {}
variable "production_account_email" {}
variable "aws_region" {}

variable "kms__key_id" {}
variable "kms__key_alias_arn" {}


module "code-build-artifacts" {
  source = "../../../modules/code-build-artifacts"
  organization = var.organization
  name = "lambda"
}


module "code-pipeline-artifacts" {
  source = "../../../modules/code-pipeline-artifacts"
  organization = var.organization
  name = "lambda"
  region = var.aws_region
}

module "code-pipeline-artifacts-eu-west-1" {
  source = "../../../modules/code-pipeline-artifacts"
  organization = var.organization
  name = "lambda-eu-west-1"
  region = "eu-west-1"
}

module "deploy-role-for-development" {
  providers = {
    aws = aws.homepage-development
    aws.shared-services = aws
  }
  source = "../../../modules/cloudformation-deploy-role"
  shared_services_account_id = var.shared_services_account_id
  code_build_artifacts_arn = module.code-build-artifacts.arn
  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
  kms__key_id = var.kms__key_id
}

module "deploy-role-for-production" {
  providers = {
    aws = aws.homepage-production
    aws.shared-services = aws
  }
  source = "../../../modules/cloudformation-deploy-role"
  shared_services_account_id = var.shared_services_account_id
  code_build_artifacts_arn = module.code-build-artifacts.arn
  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
  kms__key_id = var.kms__key_id
}


module "artifacts-bucket-policy" {
  source = "../../../modules/artifacts-bucket-policy"
  code_build_artifacts_bucket = module.code-build-artifacts.bucket
  code_build_artifacts_id = module.code-build-artifacts.id
  code_build_role_arn = module.lambda-ses-code-build.role_arn

  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket
  code_pipeline_artifacts_id = module.code-pipeline-artifacts.id
  code_pipeline_role_arn = module.lambda-ses-code-pipeline-master-to-production.role_arn

  development_account_id = var.development_account_id
  production_account_id = var.production_account_id

}