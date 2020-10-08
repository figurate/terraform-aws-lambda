data "archive_file" "function" {
  source_file = "${path.module}/lambda_handler.py"
  output_path = "rds-instance-snapshot.zip"
  type        = "zip"
}

module "function" {
  source = "../.."

  function_name    = var.function_name
  filename         = data.archive_file.function.output_path
  handler          = "lambda_handler"
  runtime          = var.runtime
  role             = var.role
  environment      = var.environment
  source_code_hash = data.archive_file.function.output_base64sha256
}
