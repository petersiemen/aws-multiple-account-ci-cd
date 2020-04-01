resource "aws_ses_email_identity" "email" {
  email = var.email_address
}
