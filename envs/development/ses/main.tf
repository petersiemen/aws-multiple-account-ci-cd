variable "development_account_email" {}

module "ses" {
  source = "../../../modules/ses"
  email_address = var.development_account_email
}

