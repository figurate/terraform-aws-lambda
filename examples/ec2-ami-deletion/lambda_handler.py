import re
from datetime import datetime, timedelta

import boto3


def lambda_handler(event):
    ec2_images = get_ec2_images(event)

    protected_ami_ids = get_protected_ami_ids(ec2_images)

    for image in filter(lambda i: i.image_id not in protected_ami_ids, ec2_images):
        print(f'Deregistering {image.name} ({image.id})')
        if event['DryRun'] != 'true':
            image.deregister()

    remove_unattached_snapshots(event, '.*from SourceAmi (ami-.*) from.*')


def get_ec2_images(event):
    ec2 = boto3.client('ec2')

    if 'ImageNameFilter' in event:
        return ec2.images.filter(Owners=["self"], Filters=[
            {"Name": "name", "Values": [event['ImageNameFilter']]}
        ])
    else:
        return ec2.images.filter(Owners=["self"])


def get_protected_ami_ids(ec2_images):
    ec2 = boto3.client('ec2')

    images_in_use = { instance.image_id for instance in ec2.instances.all()}

    young_images = set()
    for image in ec2_images:
        created_at = datetime.strptime(image.creation_date, "%Y-%m-%dT%H:%M:%S.000Z")
        if created_at > datetime.now() - timedelta(90):
            young_images.add(image.id)

    latest_dict = dict()
    for image in ec2_images:
        split = image.name.split('-')
        try:
            timestamp = int(split[-1])
        except ValueError:
            continue
        name = '-'.join(split[:-1])

        if (name not in latest_dict or timestamp > latest_dict[name][0]):
            latest_dict[name] = (timestamp, image)

    latest_images = {image.id for (_, image) in latest_dict.values()}

    return images_in_use | young_images | latest_images


def remove_unattached_snapshots(event, description_filter):
    ec2 = boto3.client('ec2')

    all_images = [image.id for image in ec2.images.all()]
    for snapshot in ec2.snapshots.filter(OwnerIds=["self"]):
        print(f'Checking snapshot {snapshot.id}')
        match = re.match(rf"{description_filter}", snapshot.description)
        if match and match.groups()[0] not in all_images:
            print(f'Deleting snapshot {snapshot.id}')
            if event['DryRun'] != 'true':
                snapshot.delete()
