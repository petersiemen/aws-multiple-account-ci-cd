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
    clone_url_http = "fake__clone_url_http"
    repository_arn = "fake__repository_arn"
    repository_name = "fake__repository_name"
  }
}

dependency "code-build" {
  config_path = "../code-build"
  mock_outputs_allowed_terraform_commands = [
    "validate",
    "plan",
    "destroy"]

  mock_outputs = {
    project_name = "fake__project_name"
  }
}


inputs = {
  code_commit__repository_name = dependency.code-commit.outputs.repository_name

  code_build_artifacts__arn = dependency.code-build-artifacts.outputs.arn
  code_build_artifacts__bucket = dependency.code-build-artifacts.outputs.bucket

  code_build__project_name = dependency.code-build.outputs.project_name
}
