import json
import boto3
import datetime
import os
from botocore.exceptions import ClientError

table_name = os.environ.get('TABLE_NAME', 'PortfolioViews')
views_table = boto3.resource('dynamodb').Table(table_name)

def lambda_handler(event, context):
    try:
        now = datetime.datetime.now(datetime.UTC).strftime("%Y-%m-%dT%H:%M:%SZ")

        response = views_table.update_item(
            Key={'PageId': '/resume'},
            UpdateExpression=(
                'SET ViewCount = if_not_exists(ViewCount, :zero) + :n, '
                'LastViewed = :now'
            ),
            ExpressionAttributeValues={
                ':n': 1,
                ':zero': 0,
                ':now': now
            },
            ReturnValues='UPDATED_NEW'
        )
        
        new_count = int(response['Attributes']['ViewCount'])
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'View count updated',
                'newViewCount': new_count
            })
        }

    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': 'Failed to update view count',
                'details': e.response['Error']['Message']
            })
        }