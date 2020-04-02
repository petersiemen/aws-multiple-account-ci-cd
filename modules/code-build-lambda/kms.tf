resource "aws_kms_grant" "access-from-code-build" {
  name = "access-from-development"
  //  key_id = aws_kms_key.codepipeline-key.key_id
  key_id = var.kms_key_id
  grantee_principal = aws_iam_role.codebuild-role.arn
//  grantee_principal = var.code_build_role_arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}
