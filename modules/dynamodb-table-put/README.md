## Requirements

No requirements.

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment variables to configure the Lambda function | `map(string)` | `{}` | no |
| function\_name | Name of the Lambda function | `string` | `"dynamodb-table-put"` | no |
| role | IAM role assumed by the Lambda function | `string` | `"dynamodb-lambda-role"` | no |
| runtime | A runtime to use for the function (leave blank to use default runtime) | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| function\_name | n/a |

