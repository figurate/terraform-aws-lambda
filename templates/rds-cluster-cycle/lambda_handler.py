import boto3
from botocore.exceptions import ClientError


def lambda_handler(event):
    cluster_name = get_cluster_name(event)
    result = None
    if event['Action'] == 'StartIntance':
        result = start_cluster(cluster_name)
    elif event['Action'] == 'StopIntance':
        result = stop_cluster(cluster_name)
    print(result)


def get_cluster_name(event):
    if event['ClusterName']:
        return event['ClusterName']

    lambda_ref = boto3.client('lambda')
    try:
        lambda_config = lambda_ref.get_function_configuration(
            FunctionName='RdsCycleCluster'
        )
        return lambda_config['Environment']['Variables']['ClusterName']
    except ClientError as e:
        print(e)


def start_cluster(cluster_name):
    rds = boto3.client('rds')
    try:
        result = rds.start_db_cluster(
            DBClusterIdentifier=cluster_name
        )
        return result
    except ClientError as e:
        print(e)


def stop_cluster(cluster_name):
    rds = boto3.client('rds')
    try:
        result = rds.stop_db_cluster(
            DBClusterIdentifier=cluster_name
        )
        return result
    except ClientError as e:
        print(e)
