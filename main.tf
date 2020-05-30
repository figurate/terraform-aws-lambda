/**
 * # ![AWS](aws-logo.png) Lambda Function
 *
 * Purpose: Provision a Lambda Function in AWS.
 *
 * Rationale: Apply standards provide templates for Lambda functions.
 */
data "archive_file" "function" {
  source_dir  = "${path.module}/templates/${var.template}"
  output_path = "${var.template}.zip"
  type        = "zip"
}

data "aws_iam_role" "role" {
  name = var.role
}

resource "aws_lambda_function" "function" {
  function_name    = var.function_name
  role             = data.aws_iam_role.role.arn
  filename         = data.archive_file.function.output_path
  handler          = "${var.function_name}.${local.templates[var.template]["lambda_handler"]}"
  runtime          = var.runtime != null ? var.runtime : local.templates[var.template]["default_runtime"]
  source_code_hash = data.archive_file.function.output_base64sha256
}
