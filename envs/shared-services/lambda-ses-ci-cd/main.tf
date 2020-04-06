variable "organization" {}
variable "shared_services_account_id" {}
variable "development_account_id" {}
variable "development_account_email" {}
variable "production_account_id" {}
variable "production_account_email" {}
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


module "code-build-lambda" {
  source = "../../../modules/code-build-lambda"

  development_account_id = var.development_account_id
  code_commit_clone_url_http = module.code-commit.clone_url_http
  code_commit_repository_name = module.code-commit.repository_name

  code_build_artifacts_arn = module.code-build-artifacts.arn
  code_build_artifacts_bucket = module.code-build-artifacts.bucket
  //  code_build_artifacts_id = module.code-build-artifacts.id

  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
  kms_key_id = var.kms__key_id

  name = local.name
}

module "code-pipeline-develop-to-development" {
  source = "../../../modules/code-pipeline-lambda"
  organization = var.organization
  account_id_for_deployment = var.development_account_id
  shared_services_account_id = var.shared_services_account_id

  kms_key_id = var.kms__key_id
  kms_key_alias_arn = var.kms__key_alias_arn

  code_commit_repository_name = module.code-commit.repository_name
  code_commit_repository_branch_name = "develop"

  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket

  code_build_project_name = module.code-build-lambda.project_name
  code_build_role_arn = module.code-build-lambda.role_arn

  cloudformation_deploy_role_arn = module.deploy-role-for-development.arn
  ses_verified_email_address = var.development_account_email

  name = "${local.name}-develop-to-development"
}

module "code-pipeline-master-to-production" {
  source = "../../../modules/code-pipeline-lambda"
  organization = var.organization
  account_id_for_deployment = var.production_account_id
  shared_services_account_id = var.shared_services_account_id

  kms_key_id = var.kms__key_id
  kms_key_alias_arn = var.kms__key_alias_arn

  code_commit_repository_name = module.code-commit.repository_name
  code_commit_repository_branch_name = "master"

  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket

  code_build_project_name = module.code-build-lambda.project_name
  code_build_role_arn = module.code-build-lambda.role_arn

  cloudformation_deploy_role_arn = module.deploy-role-for-production.arn

  ses_verified_email_address = var.production_account_email

  name = "${local.name}-master-to-production"
}

module "artifacts-bucket-policy" {
  source = "../../../modules/artifacts-bucket-policy"
  code_build_artifacts_bucket = module.code-build-artifacts.bucket
  code_build_artifacts_id = module.code-build-artifacts.id
  code_build_role_arn = module.code-build-lambda.role_arn

  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket
  code_pipeline_artifacts_id = module.code-pipeline-artifacts.id
  code_pipeline_role_arn = module.code-pipeline-master-to-production.role_arn

  development_account_id = var.development_account_id
  production_account_id = var.production_account_id

}