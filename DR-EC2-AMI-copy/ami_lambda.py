import os
import boto3
from datetime import datetime, timezone

def lambda_handler(event, context):
    # Get the region names from environment variables
    source_region = os.environ['SOURCE_REGION']
    destination_region = os.environ['DESTINATION_REGION']

    # Initialize boto3 clients for both regions
    source_client = boto3.client('ec2', region_name=source_region)
    dest_client = boto3.client('ec2', region_name=destination_region)

    # Find the AMIs created today in the source region
    response = source_client.describe_images(
        Owners=['self'],
        Filters=[{'Name': 'state', 'Values': ['available']}]
    )
    
    today = datetime.now(timezone.utc).date()
    todays_amis = [image for image in response['Images'] if datetime.strptime(image['CreationDate'], "%Y-%m-%dT%H:%M:%S.%f%z").date() == today]

    if todays_amis:
        for ami in todays_amis:
            print(f"Copying AMI: {ami['ImageId']} ({ami['CreationDate']})")

            # Copy the AMI to the destination region
            copy_response = dest_client.copy_image(
                SourceRegion=source_region,
                SourceImageId=ami['ImageId'],
                Name=ami['Name'],
                Description=ami['Description']
            )
            print(f"AMI copy initiated. New AMI ID in destination region: {copy_response['ImageId']}")
    else:
        print('No AMIs found with today\'s date in the source region.')

    return {
        'statusCode': 200,
        'body': 'AMI copy process completed.'
    }
