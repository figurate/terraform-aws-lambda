"""
DynamoDB Put Item.

An AWS Lambda function used to add items to a DynamoDB table.
"""
import json
import os

import boto3
from botocore.exceptions import ClientError

data_types = os.environ['DataTypes']
table_name = os.environ['TableName']


def lambda_handler(event):
    item = json.loads(event['Item'])

    put_item(dict2payload(item))


def dict2payload(item):
    retval = {}
    for key, value in item.items():
        data_type = data_types[key] if key in data_types else 'S'
        retval[key] = {data_type: value}
    return retval


def put_item(payload):
    dynamodb = boto3.client('dynamodb')
    try:
        dynamodb.put_item(TableName=table_name, Item=payload)
    except ClientError as e:
        print(e)
