variable "organization" {}
variable "name" {}
variable "account_id_for_deployment" {}
variable "shared_services_account_id" {}

variable "kms_key_id" {}
variable "kms_key_alias_arn" {}

variable "code_commit_repository_name" {}
variable "code_commit_repository_branch_name" {}

variable "code_pipeline_artifacts_bucket" {}
variable "code_pipeline_artifacts_arn" {}

variable "code_build_project_name" {}
variable "code_build_role_arn" {}

variable "cloudformation_deploy_role_arn" {}

variable "deploy_stage_parameter_overrides" {}
variable "deploy_stage_region" {}