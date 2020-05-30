module "function" {
  source = "../.."

  function_name = var.function_name
  template      = "iam-user-keyrotation"
  runtime       = var.runtime
  role          = var.role
  environment   = var.environment
}
