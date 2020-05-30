"""
DynamoDB Import Comma-separated values (CSV) document.

An AWS Lambda function used to import batch records to a DynamoDB table.
"""
import csv
import json
import os
import uuid

import boto3
from botocore.exceptions import ClientError

data_types = os.environ['DataTypes']
table_name = os.environ['TableName']
item_template = json.loads(os.environ['ItemTemplate'])
auto_generate_key = os.environ['AutoGenerateKey']


def lambda_handler(event):
    bucket = event['Records'][0]['s3']['bucket']['name']
    filename = event['Records'][0]['s3']['object']['key']

    import_file(bucket, filename)


def import_file(bucket, filename):
    s3 = boto3.client('s3')
    dynamodb = boto3.client('dynamodb')
    try:
        data = s3.get_object(Bucket=bucket, Key=filename)['Body'].read().decode('utf-8')
        csv_reader = csv.reader(data.splitlines(), delimiter=',')
        columns = None
        linenum = 0
        for row in csv_reader:
            if linenum == 0:
                # use header row to identify the columns..
                columns = row
            else:
                import_row(row2map(columns, row), dynamodb)
            linenum += 1
    except ClientError as e:
        print(e)


def row2map(columns, row):
    retval = {}
    if (auto_generate_key):
        retval['UUID'] = uuid.uuid4().hex
    for key, value in item_template.items():
        data_type = data_types[key] if key in data_types else 'S'
    retval[key] = {data_type: value}

    for column in columns:
        if len(row[columns.index(column)]) > 0:
            data_type = data_types[column] if column in data_types else 'S'
            retval[column] = {data_type: row[columns.index(column)]}
    return retval


def import_row(row, client):
    try:
        client.put_item(TableName=table_name, Item=row)
    except ClientError as e:
        print(e)
