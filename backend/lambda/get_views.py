import json
import boto3
import datetime
from botocore.exceptions import ClientError


table_name = 'PortfolioViews'
views_table = boto3.resource('dynamodb').Table(table_name)

def lambda_handler(event, context):
    try:
        response = views_table.get_item(
            Key={'PageId': '/resume'}
        )

        item = response.get('Item')

        if not item or 'ViewCount' not in item:
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': 'View count not found',
                    'viewCount': 0
                })
            }

        view_count = int(item['ViewCount'])

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'View count retrieved',
                'viewCount': view_count
            })
        }

    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': 'Failed to get view count',
                'details': e.response['Error']['Message']
            })
        }