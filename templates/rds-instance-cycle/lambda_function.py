import boto3
from botocore.exceptions import ClientError


def lambda_handler(event):
    instance_name = get_instance_name(event)
    result = None
    if event['Action'] == 'StartIntance':
        result = start_instance(instance_name)
    elif event['Action'] == 'StopIntance':
        result = stop_instance(instance_name)
    print(result)


def get_instance_name(event):
    if event['InstanceName']:
        return event['InstanceName']

    lambda_ref = boto3.client('lambda')
    try:
        lambda_config = lambda_ref.get_function_configuration(
            FunctionName='RdsCycleInstance'
        )
        return lambda_config['Environment']['Variables']['InstanceName']
    except ClientError as e:
        print(e)


def start_instance(instance_name):
    rds = boto3.client('rds')
    try:
        result = rds.start_db_instance(
            DBInstanceIdentifier=instance_name
        )
        return result
    except ClientError as e:
        print(e)


def stop_instance(instance_name):
    rds = boto3.client('rds')
    try:
        result = rds.stop_db_instance(
            DBInstanceIdentifier=instance_name
        )
        return result
    except ClientError as e:
        print(e)
