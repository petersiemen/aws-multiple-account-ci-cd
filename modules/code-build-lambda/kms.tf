resource "aws_kms_grant" "access-from-code-build" {
  name = "access-from-development"
  key_id = var.kms_key_id
  grantee_principal = aws_iam_role.codebuild-role.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}
