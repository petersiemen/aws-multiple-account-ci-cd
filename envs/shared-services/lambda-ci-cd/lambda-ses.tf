module "lambda-ses-code-commit" {
  source = "../../../modules/code-commit"
  name = local.lambda_ses
}

module "lambda-ses-code-build" {
  source = "../../../modules/code-build-lambda"

  development_account_id = var.development_account_id
  code_commit_clone_url_http = module.lambda-ses-code-commit.clone_url_http
  code_commit_repository_name = module.lambda-ses-code-commit.repository_name

  code_build_artifacts_arn = module.code-build-artifacts.arn
  code_build_artifacts_bucket = module.code-build-artifacts.bucket

  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
  kms_key_id = var.kms__key_id

  name = local.lambda_ses
}

module "lambda-ses-code-pipeline-develop-to-development" {
  source = "../../../modules/code-pipeline-lambda"
  organization = var.organization
  account_id_for_deployment = var.development_account_id
  shared_services_account_id = var.shared_services_account_id

  kms_key_id = var.kms__key_id
  kms_key_alias_arn = var.kms__key_alias_arn

  code_commit_repository_name = module.lambda-ses-code-commit.repository_name
  code_commit_repository_branch_name = "develop"

  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket

  code_build_project_name = module.lambda-ses-code-build.project_name
  code_build_role_arn = module.lambda-ses-code-build.role_arn

  cloudformation_deploy_role_arn = module.deploy-role-for-development.arn

  deploy_stage_parameter_overrides = jsonencode({
    EMAIL: var.development_account_email
  })
  deploy_stage_region = "eu-west-1"

  name = "${local.lambda_ses}-develop-to-development"


}

module "lambda-ses-code-pipeline-master-to-production" {
  source = "../../../modules/code-pipeline-lambda"
  organization = var.organization
  account_id_for_deployment = var.production_account_id
  shared_services_account_id = var.shared_services_account_id

  kms_key_id = var.kms__key_id
  kms_key_alias_arn = var.kms__key_alias_arn

  code_commit_repository_name = module.lambda-ses-code-commit.repository_name
  code_commit_repository_branch_name = "master"

  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket

  code_build_project_name = module.lambda-ses-code-build.project_name
  code_build_role_arn = module.lambda-ses-code-build.role_arn

  cloudformation_deploy_role_arn = module.deploy-role-for-production.arn

  deploy_stage_parameter_overrides = jsonencode({
    EMAIL: var.development_account_email
  })
  deploy_stage_region = "eu-west-1"

  name = "${local.lambda_ses}-master-to-production"
}