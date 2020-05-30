module "function" {
  source = "../.."

  function_name = var.function_name
  template      = "dynamodb-table-import"
  runtime       = var.runtime
  role          = var.role
  environment   = var.environment
}
