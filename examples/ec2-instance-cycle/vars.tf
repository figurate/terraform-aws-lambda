variable "function_name" {
  description = "Name of the Lambda function"
  default     = "ec2-instance-cycle"
}

variable "runtime" {
  description = "A runtime to use for the function (leave blank to use default runtime)"
  default     = "python3.6"
}

variable "environment" {
  description = "Environment variables to configure the Lambda function"
  type        = map(string)
  default     = {}
}

variable "role" {
  description = "IAM role assumed by the Lambda function"
  default     = "iam-lambda-role"
}
