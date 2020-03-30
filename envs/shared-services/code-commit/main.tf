locals {
  name = "homepage"
}

module "code-build" {
  source = "../../../modules/code-commit"
  name = local.name
}