variable "organization" {}

module "code-build-artifacts" {
  source = "../../../modules/code-build-artifacts"
  organization = var.organization
  name = "homepage"
}