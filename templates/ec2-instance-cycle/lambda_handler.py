import boto3
from botocore.exceptions import ClientError


def lambda_handler(event):
    instance_ids = get_instance_ids(event)
    if event['Action'] == 'StartInstance':
        result = start_instances(instance_ids)
        print(result)
    elif event['Action'] == 'StopInstance':
        result = stop_instances(instance_ids)
        print(result)


def get_instance_ids(event):
    if 'InstanceId' in event:
        return [event['InstanceId']]

    ec2 = boto3.client('ec2')

    if 'Environment' in event:
        result = ec2.describe_instances(Filters=[{
            "Name": "tag:Environment",
            "Values": [event['Environment']]
        }])
        instances = [i for r in result['Reservations'] for i in r['Instances']]
        return list(map(lambda i: i['InstanceId'], instances))

    try:
        lambda_config = ec2.get_function_configuration(
            FunctionName='Ec2CycleInstance'
        )
        return [lambda_config['Environment']['Variables']['InstanceId']]
    except ClientError as e:
        print(e)


def start_instances(instance_ids):
    ec2 = boto3.client('ec2')
    try:
        result = ec2.start_instances(InstanceIds=instance_ids)
        return result
    except ClientError as e:
        print(e)


def stop_instances(instance_ids):
    ec2 = boto3.client('ec2')
    try:
        result = ec2.stop_instances(InstanceIds=instance_ids)
        return result
    except ClientError as e:
        print(e)
