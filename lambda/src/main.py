import os
import boto3
import boto3

def handler(event, context): 
    role_arn = os.environ['DESTINATION_IAM_ROLE_ARN']
    target_ddb_name = os.environ['DESTINATION_DYNAMODB_TABLE_ID']
    target_ddb_region = os.environ['DESTINATION_DYNAMODB_REGION']

    sts_response = get_credentials(role_arn)
    
    dynamodb = boto3.client('dynamodb', region_name=target_ddb_region,
                            aws_access_key_id = sts_response['AccessKeyId'],
                            aws_secret_access_key = sts_response['SecretAccessKey'],
                            aws_session_token = sts_response['SessionToken'])

    Records = event['Records']
 
    for record in Records:
        event_name = record['eventName']
        
        if event_name == 'REMOVE':
            response = dynamodb.delete_item(TableName=target_ddb_name,Key=record['dynamodb']['Keys'])
        else:
            response = dynamodb.put_item(TableName=target_ddb_name,Item=record['dynamodb']['NewImage'])
            
def get_credentials(role_arn):
    sts_client = boto3.client('sts')
    assumed_role_object=sts_client.assume_role(
        RoleArn=role_arn,
        RoleSessionName="cross_acct_lambda"
    )
    sts_response=assumed_role_object['Credentials']
    return sts_response