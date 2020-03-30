variable "organization" {}
variable "shared_services_account_id" {}
variable "aws_region" {}


variable "code_commit__repository_name" {}

variable "code_build_artifacts__arn" {}
variable "code_build_artifacts__bucket" {}
variable "code_build__project_name" {}

module "code-pipeline-development" {
  source = "../../../modules/code-pipeline"
  organization = var.organization

  code_commit_repository_name = var.code_commit__repository_name
  code_commit_repository_branch_name = "develop"

  code_build_artifacts_arn = var.code_build_artifacts__arn
  code_build_artifacts_bucket = var.code_build_artifacts__bucket

  code_build_project_name = var.code_build__project_name

  s3_static_website_bucket_arn = "arn:aws:s3:::preview.petersiemen.de"
  s3_static_website_bucket_name = "preview.petersiemen.de"
  name = "homepage-develop-to-development"
}

module "code-pipeline-production" {
  source = "../../../modules/code-pipeline"
  organization = var.organization

  code_commit_repository_name = var.code_commit__repository_name
  code_commit_repository_branch_name = "master"

  code_build_artifacts_arn = var.code_build_artifacts__arn
  code_build_artifacts_bucket = var.code_build_artifacts__bucket

  code_build_project_name = var.code_build__project_name

  s3_static_website_bucket_arn = "arn:aws:s3:::petersiemen.de"
  s3_static_website_bucket_name = "petersiemen.de"
  name = "homepage-master-to-production"
}