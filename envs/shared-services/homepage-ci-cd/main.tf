variable "organization" {}
variable "shared_services_account_id" {}
variable "development_account_id" {}
variable "aws_region" {}

locals {
  name = "homepage"
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

module "code-build" {
  source = "../../../modules/code-build"

  code_commit_clone_url_http = module.code-commit.clone_url_http
  code_commit_repository_name = module.code-commit.repository_name

  code_build_artifacts_arn = module.code-build-artifacts.arn
  code_build_artifacts_bucket = module.code-build-artifacts.bucket
  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn


  name = local.name
}

module "code-pipeline-master" {
  source = "../../../modules/code-pipeline"
  organization = var.organization

  code_commit_repository_name = module.code-commit.repository_name
  code_commit_repository_branch_name = "master"

  code_build_project_name = module.code-build.project_name
  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket
  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn

  s3_static_website_bucket_arn = "arn:aws:s3:::preview.petersiemen.de"
  s3_static_website_bucket_name = "preview.petersiemen.de"
  name = "homepage-develop-to-development"
}