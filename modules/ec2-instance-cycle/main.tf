module "function" {
  source = "../.."

  function_name = var.function_name
  template      = "ec2-instance-cycle"
  runtime       = var.runtime
  role          = var.role
  environment   = var.environment
}
