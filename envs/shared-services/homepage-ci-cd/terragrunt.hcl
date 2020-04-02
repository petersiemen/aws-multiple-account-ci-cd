include {
  path = find_in_parent_folders()
}
//
//dependency "kms" {
//  config_path = "../kms"
//  mock_outputs_allowed_terraform_commands = [
//    "validate",
//    "plan",
//    "destroy"]
//
//  mock_outputs = {
//    key_id = "fake__key_id"
//    key_alias_arn = "fake__key_alias_arn"
//  }
//}
//
//
//inputs = {
//  kms__key_id = dependency.kms.outputs.key_id
//  kms__key_alias_arn = dependency.kms.outputs.key_alias_arn
//}