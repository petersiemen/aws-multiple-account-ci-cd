//resource "aws_kms_key" "codepipeline-key" {}
//resource "aws_kms_alias" "s3-key-alias" {
//  name = "alias/codepipeline-artifacts"
//  target_key_id = aws_kms_key.codepipeline-key.key_id
//}

//resource "aws_kms_grant" "access-from-development" {
//  name = "access-from-development"
//  //  key_id = aws_kms_key.codepipeline-key.key_id
//  key_id = var.kms_key_id
//  grantee_principal = var.cloudformation_deploy_role_arn
//  operations = [
//    "Encrypt",
//    "Decrypt",
//    "GenerateDataKey"]
//}

resource "aws_kms_grant" "access-from-code-build" {
  name = "access-from-development"
  //  key_id = aws_kms_key.codepipeline-key.key_id
  key_id = var.kms_key_id
  grantee_principal = var.code_build_role_arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}

resource "aws_kms_grant" "access-from-shared-services" {
  name = "access-from-shared-services"
  //  key_id = aws_kms_key.codepipeline-key.key_id
  key_id = var.kms_key_id
  grantee_principal = aws_iam_role.codepipeline-role.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}
