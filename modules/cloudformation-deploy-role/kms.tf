provider "aws" {
  alias = "shared-services"
}

resource "aws_kms_grant" "grant-for-deploy-role" {
  provider = aws.shared-services

  name = "grant-for-deploy"
  key_id = var.kms__key_id
  grantee_principal = aws_iam_role.cloudformation-deploy-role.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}
