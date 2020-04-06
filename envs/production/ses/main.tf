variable "production_account_email" {}
variable "domain" {}

module "ses" {
  source = "../../../modules/ses"
  email_address = var.production_account_email
  domain = var.domain
}

