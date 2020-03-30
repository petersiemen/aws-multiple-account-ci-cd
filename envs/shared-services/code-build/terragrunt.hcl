include {
  path = find_in_parent_folders()
}


dependency "code-build-artifacts" {
  config_path = "../code-build-artifacts"
  mock_outputs_allowed_terraform_commands = [
    "validate",
    "plan",
    "destroy"]

  mock_outputs = {
    arn = "fake__arn"
    bucket = "fake_bucket"
  }
}

dependency "code-commit" {
  config_path = "../code-commit"
  mock_outputs_allowed_terraform_commands = [
    "validate",
    "plan",
    "destroy"]

  mock_outputs = {
    bucket_regional_domain_name = "fake___bucket_regional_domain_name"
    bucket_name = "fake__bucket_name"

    clone_url_http = "fake__clone_url_http"
    repository_arn = "fake__repository_arn"
    repository_name = "fake__repository_name"
  }
}


inputs = {
  code_commit__clone_url_http = dependency.code-commit.outputs.clone_url_http
  code_commit__repository_arn = dependency.code-commit.outputs.repository_arn
  code_commit__repository_name = dependency.code-commit.outputs.repository_name

  code_build_artifacts__arn = dependency.code-build-artifacts.outputs.arn
  code_build_artifacts__bucket = dependency.code-build-artifacts.outputs.bucket
}
