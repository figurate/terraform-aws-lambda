variable "function_name" {
  description = "Name of the Lambda function"
}

variable "template" {
  description = "A predefined function template"
}

variable "runtime" {
  description = "A runtime to use for the function (leave blank to use default runtime)"
  default     = null
}

variable "role" {
  description = "IAM role assumed by the Lambda function"
}
