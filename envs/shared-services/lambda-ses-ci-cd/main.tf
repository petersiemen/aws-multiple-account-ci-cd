variable "organization" {}
variable "shared_services_account_id" {}
variable "development_account_id" {}
variable "aws_region" {}

variable "kms__key_id" {}
variable "kms__key_alias_arn" {}

locals {
  name = "lambda-ses"
}

module "code-commit" {
  source = "../../../modules/code-commit"
  name = local.name
}

module "code-build-artifacts" {
  source = "../../../modules/code-build-artifacts"
  organization = var.organization
  name = local.name
}

module "code-pipeline-artifacts" {
  source = "../../../modules/code-pipeline-artifacts"
  organization = var.organization
  name = local.name
}

module "cloudformation-deploy-role-for-development" {
  providers = {
    aws = aws.homepage-development
  }
  source = "../../../modules/cloudformation-deploy-role"
  shared_services_account_id = var.shared_services_account_id
  code_build_artifacts_arn = module.code-build-artifacts.arn
  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
}

resource "aws_kms_grant" "grant-for-deploy-role" {
  name = "grant-for-deploy"
  key_id = var.kms__key_id
  grantee_principal = module.cloudformation-deploy-role-for-development.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}


module "code-build-lambda" {
  source = "../../../modules/code-build-lambda"

  development_account_id = var.development_account_id
  code_commit_clone_url_http = module.code-commit.clone_url_http
  code_commit_repository_name = module.code-commit.repository_name

  code_build_artifacts_arn = module.code-build-artifacts.arn
  code_build_artifacts_bucket = module.code-build-artifacts.bucket
  code_build_artifacts_id = module.code-build-artifacts.id

  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn

  name = local.name
}

module "code-pipeline-master" {
  source = "../../../modules/code-pipeline-lambda"
  organization = var.organization
  development_account_id = var.development_account_id
  shared_services_account_id = var.shared_services_account_id

  kms_key_id = var.kms__key_id
  kms_key_alias_arn = var.kms__key_alias_arn

  code_commit_repository_name = module.code-commit.repository_name
  code_commit_repository_branch_name = "master"

  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket
  code_pipeline_artifacts_id = module.code-pipeline-artifacts.id

  code_build_project_name = module.code-build-lambda.project_name
  code_build_role_arn = module.code-build-lambda.role_arn

  cloudformation_deploy_role_arn = module.cloudformation-deploy-role-for-development.arn

  name = "${local.name}-master"


}