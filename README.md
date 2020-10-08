# ![AWS](aws-logo.png) Lambda Function

![AWS Lambda Function](aws\_lambda\_function.png)

Purpose: Provision a Lambda Function in AWS.

Rationale: Apply standards provide templates for Lambda functions.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment variables to configure the Lambda function | `map(string)` | `{}` | no |
| filename | File containing the function | `any` | n/a | yes |
| function\_name | Name of the Lambda function | `any` | n/a | yes |
| handler | Entry point to the lambda function | `any` | n/a | yes |
| role | IAM role assumed by the Lambda function | `any` | n/a | yes |
| runtime | A runtime to use for the function (leave blank to use default runtime) | `any` | `null` | no |
| source\_code\_hash | Hash used to detect function changes on update | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| function\_name | n/a |

