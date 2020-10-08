variable "function_name" {
  description = "Name of the Lambda function"
}

variable "filename" {
  description = "File containing the function"
}

variable "handler" {
  description = "Entry point to the lambda function"
}

variable "runtime" {
  description = "A runtime to use for the function (leave blank to use default runtime)"
  default     = null
}

variable "environment" {
  description = "Environment variables to configure the Lambda function"
  type        = map(string)
  default     = {}
}

variable "role" {
  description = "IAM role assumed by the Lambda function"
}

variable "source_code_hash" {
  description = "Hash used to detect function changes on update"
}
