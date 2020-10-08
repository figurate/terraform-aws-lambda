data "archive_file" "function" {
  source_file = "handler.js"
  output_path = "cloudfront-request-rewrite.zip"
  type        = "zip"
}

module "function" {
  source = "../.."

  function_name    = var.function_name
  filename         = data.archive_file.function.output_path
  handler          = "handler"
  runtime          = var.runtime
  role             = var.role
  environment      = var.environment
  source_code_hash = data.archive_file.function.output_base64sha256
}
