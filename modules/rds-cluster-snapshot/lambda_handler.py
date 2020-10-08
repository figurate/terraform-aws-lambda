from datetime import datetime

import boto3
from botocore.exceptions import ClientError


def lambda_handler(event):
    cluster_name = get_cluster_name(event)
    result = snapshot_cluster(cluster_name)
    print(result)


def get_cluster_name(event):
    if event['ClusterName']:
        return event['ClusterName']

    lambda_ref = boto3.client('lambda')
    try:
        lambda_config = lambda_ref.get_function_configuration(
            FunctionName='RdsSnapshotCluster'
        )
        return lambda_config['Environment']['Variables']['ClusterName']
    except ClientError as e:
        print(e)


def snapshot_cluster(cluster_name):
    rds = boto3.client('rds')
    timestamp = datetime.now().strftime('%Y-%m-%d-%H-%M')
    snapshot_identifier = '%s-%s' % (cluster_name, timestamp)
    try:
        result = rds.create_db_snapshot(
            DBClusterIdentifier=cluster_name,
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
