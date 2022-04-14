/**
 * # ![AWS](aws-logo.png) Lambda Function
 *
 * [![CI](https://github.com/figurate/terraform-aws-lambda-function/actions/workflows/main.yml/badge.svg)](https://github.com/figurate/terraform-aws-lambda-function/actions/workflows/main.yml)
 *
 *
 * ![AWS Lambda Function](aws_lambda_function.png)
 *
 * Purpose: Provision a Lambda Function in AWS.
 *
 * Rationale: Apply standards provide templates for Lambda functions.
 */
data "aws_iam_role" "role" {
  name = var.role
}

resource "aws_lambda_function" "function" {
  function_name    = var.function_name
  role             = data.aws_iam_role.role.arn
  filename         = var.filename
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = var.source_code_hash

  tracing_config {
    mode = "Active"
  }

  dynamic "environment" {
    for_each = length(var.environment) > 0 ? [1] : []
    content {
      variables = var.environment
    }
  }
}
