variable "organization" {}
variable "shared_services_account_id" {}
variable "development_account_id" {}
variable "aws_region" {}


locals {
  name = "lambda-ses"
}

module "code-build-artifacts" {
  source = "../../../modules/code-build-artifacts"
  organization = var.organization
  name = local.name
  development_account_id = var.development_account_id
}

module "cloudformation-deploy-role-for-development" {
  providers = {
    aws = aws.homepage-development
  }
  source = "../../../modules/cloudformation-deploy-role"
  shared_services_account_id = var.shared_services_account_id
  code_build_artifacts_arn = module.code-build-artifacts.arn
}

module "code-commit" {
  source = "../../../modules/code-commit"
  name = local.name
}


module "code-build" {
  source = "../../../modules/code-build"
  organization = var.organization
  aws_region = var.aws_region
  aws_account_id = var.shared_services_account_id

  code_commit_clone_url_http = module.code-commit.clone_url_http
  code_commit_repository_name = module.code-commit.repository_name

  code_build_artifacts_arn = module.code-build-artifacts.arn
  code_build_artifacts_bucket = module.code-build-artifacts.bucket

  name = local.name
}

module "code-pipeline-master" {
  source = "../../../modules/code-pipeline-lambda"
  organization = var.organization

  code_commit_repository_name = module.code-commit.repository_name
  code_commit_repository_branch_name = "master"

  code_build_artifacts_arn = module.code-build-artifacts.arn
  code_build_artifacts_bucket = module.code-build-artifacts.bucket

  code_build_project_name = module.code-build.project_name

  cloudformation_deploy_role_arn = module.cloudformation-deploy-role-for-development.arn

  name = "${local.name}-master"
}