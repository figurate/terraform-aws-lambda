# ![AWS](aws-logo.png) Lambda Function

Purpose: Provision a Lambda Function in AWS.

Rationale: Apply standards provide templates for Lambda functions.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment variables to configure the Lambda function | `map(string)` | `{}` | no |
| function\_name | Name of the Lambda function | `any` | n/a | yes |
| role | IAM role assumed by the Lambda function | `any` | n/a | yes |
| runtime | A runtime to use for the function (leave blank to use default runtime) | `any` | `null` | no |
| template | A predefined function template | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| function\_name | n/a |

