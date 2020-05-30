import os
from datetime import datetime, timezone

import boto3
from botocore.exceptions import ClientError

key_max_age = os.environ['KeyMaxAge']


def lambda_handler(event):
    user_ids = get_user_ids(event)

    for userid in user_ids:
        rotate_access_keys(userid, key_max_age)


def get_user_ids(event):
    if 'UserId' in event:
        return [event['UserId']]

    iam = boto3.client('iam')

    if 'Group' in event:
        group = iam.get_group(GroupName=event['Group'])
        return list(map(lambda i: i['UserName'], group['Users']))

    try:
        lambdac = boto3.client('lambda')
        lambda_config = lambdac.get_function_configuration(FunctionName='IamKeyRotation')
        if 'Group' in lambda_config['Environment']['Variables']:
            group = iam.get_group(GroupName=lambda_config['Environment']['Variables']['Group'])
            return list(map(lambda i: i['UserName'], group['Users']))
        else:
            return [lambda_config['Environment']['Variables']['UserId']]
    except ClientError as e:
        print(e)


def rotate_access_keys(userid, max_age):
    iam = boto3.client('iam')

    access_keys = iam.list_access_keys(UserName=userid)

    for key in access_keys['AccessKeyMetadata']:
        if key['Status'] == 'Inactive':
            # If key already inactive delete it..
            print(f"Deleting disabled key: {key['AccessKeyId']}")
            iam.delete_access_key(UserName=userid, AccessKeyId=key['AccessKeyId'])
        elif (datetime.now(timezone.utc) - key['CreateDate']).days > max_age:
            # Disable active keys older than max_age..
            print(f"Disabling old key: {key['AccessKeyId']}")
            iam.update_access_key(UserName=userid, AccessKeyId=key['AccessKeyId'], Status='Inactive')
            # new_access_key = iam.create_access_key(UserName=userid)
