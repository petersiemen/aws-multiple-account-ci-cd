//resource "aws_kms_grant" "grant-for-deploy-role" {
//  name = "grant-for-deploy"
//  key_id = var.kms_key_id
//  grantee_principal = aws_iam_role.cloudformation-deploy-role.arn
//  operations = [
//    "Encrypt",
//    "Decrypt",
//    "GenerateDataKey"]
//}
