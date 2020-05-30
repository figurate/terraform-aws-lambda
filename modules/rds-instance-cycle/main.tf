module "function" {
  source = "../.."

  function_name = var.function_name
  template      = "rds-instance-cycle"
  runtime       = var.runtime
  role          = var.role
  environment   = var.environment
}
