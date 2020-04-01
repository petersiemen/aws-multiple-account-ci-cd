
module "homepage" {
  source = "../../../modules/code-commit"
  name = "homepage"
}

module "lambda-ses" {
  source = "../../../modules/code-commit"
  name = "lambda-ses"
}