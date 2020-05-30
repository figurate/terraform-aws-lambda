from datetime import datetime

import boto3
from botocore.exceptions import ClientError


def lambda_handler(event):
    instance_name = get_instance_name(event)
    result = snapshot_instance(instance_name)
    print(result)


def get_instance_name(event):
    if event['InstanceName']:
        return event['InstanceName']

    lambda_ref = boto3.client('lambda')
    try:
        lambda_config = lambda_ref.get_function_configuration(
            FunctionName='RdsSnapshotInstance'
        )
        return lambda_config['Environment']['Variables']['InstanceName']
    except ClientError as e:
        print(e)


def snapshot_instance(instance_name):
    rds = boto3.client('rds')
    timestamp = datetime.now().strftime('%Y-%m-%d-%H-%M')
    snapshot_identifier = '%s-%s' % (instance_name, timestamp)
    try:
        result = rds.create_db_snapshot(
            DBInstanceIdentifier=instance_name,
            DBSnapshotIdentifer=snapshot_identifier,
            Tags=[
                {
                    'Key': 'CreatedOn',
                    'Value': timestamp
                }
            ]
        )
        return result
    except ClientError as e:
        print(e)
