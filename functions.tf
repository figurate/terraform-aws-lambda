locals {
  templates = {
    ec2-instance-cycle = {
      lambda_handler  = "lambda_handler"
      default_runtime = "python3.6"
    }
  }
}