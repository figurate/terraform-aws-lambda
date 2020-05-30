module "function" {
  source = "../.."

  function_name = var.function_name
  template      = "cloudfront-request-rewrite"
  runtime       = var.runtime
  role          = var.role
  environment   = var.environment
}
