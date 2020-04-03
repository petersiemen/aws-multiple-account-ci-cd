resource "aws_kms_grant" "access-from-shared-services" {
  name = "access-from-shared-services"
  key_id = var.kms_key_id
  grantee_principal = aws_iam_role.codepipeline-role.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}
