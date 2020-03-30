variable "organization" {}
variable "shared_services_account_id" {}
variable "aws_region" {}

locals {
  name = "homepage"
}

variable "code_commit__clone_url_http" {}
variable "code_commit__repository_arn" {}
variable "code_commit__repository_name" {}

variable "code_build_artifacts__arn" {}
variable "code_build_artifacts__bucket" {}

module "code-build" {
  source = "../../../modules/code-build"
  organization = var.organization
  aws_region = var.aws_region
  aws_account_id = var.shared_services_account_id

  code_commit_clone_url_http = var.code_commit__clone_url_http
  code_commit_repository_name = var.code_commit__repository_name

  code_build_artifacts_arn = var.code_build_artifacts__arn
  code_build_artifacts_bucket = var.code_build_artifacts__bucket

  name = local.name
}