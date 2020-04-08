module "lambda-mail-forwarder-code-commit" {
  source = "../../../modules/code-commit"
  name = local.lambda_mail_forwarder
}

module "lambda-mail-forwarder-code-build" {
  source = "../../../modules/code-build-lambda"

  code_build_role_arn = module.ci-cd-roles.code_build_role_arn
  code_build_artifacts_bucket = module.code-build-artifacts.bucket
  code_commit_clone_url_http = module.lambda-ses-code-commit.clone_url_http

  name = local.lambda_mail_forwarder
}
//
//module "lambda-mail-forwarder-code-pipeline-develop-to-development" {
//  source = "../../../modules/code-pipeline-lambda"
//  organization = var.organization
//  account_id_for_deployment = var.development_account_id
//  shared_services_account_id = var.shared_services_account_id
//
//  kms_key_id = var.kms__key_id
//  kms_key_alias_arn = var.kms__key_alias_arn
//
//  code_commit_repository_name = module.lambda-mail-forwarder-code-commit.repository_name
//  code_commit_repository_branch_name = "develop"
//
//  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
//  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket
//
//  code_build_project_name = module.lambda-mail-forwarder-code-build.project_name
//  code_build_role_arn = module.lambda-mail-forwarder-code-build.role_arn
//
//  cloudformation_deploy_role_arn = module.deploy-role-for-development.arn
//  deploy_stage_parameter_overrides = jsonencode({
//    EMAIL: var.development_account_email
//    BUCKET: "mail.preview.petersiemen.net"
//  })
//
//  deploy_stage_region = "eu-west-1"
//  name = "${local.lambda_mail_forwarder}-develop-to-development"
//}
//
//module "lambda-mail-forwarder-code-pipeline-master-to-production" {
//  source = "../../../modules/code-pipeline-lambda"
//  organization = var.organization
//  account_id_for_deployment = var.production_account_id
//  shared_services_account_id = var.shared_services_account_id
//
//  kms_key_id = var.kms__key_id
//  kms_key_alias_arn = var.kms__key_alias_arn
//
//  code_commit_repository_name = module.lambda-mail-forwarder-code-commit.repository_name
//  code_commit_repository_branch_name = "master"
//
//  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
//  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket
//
//  code_build_project_name = module.lambda-mail-forwarder-code-build.project_name
//  code_build_role_arn = module.lambda-mail-forwarder-code-build.role_arn
//
//  cloudformation_deploy_role_arn = module.deploy-role-for-production.arn
//
//  deploy_stage_parameter_overrides = jsonencode({
//    EMAIL: var.development_account_email
//    BUCKET: "mail.petersiemen.net"
//  })
//
//  deploy_stage_region = "eu-west-1"
//
//  name = "${local.lambda_mail_forwarder}-master-to-production"
//}