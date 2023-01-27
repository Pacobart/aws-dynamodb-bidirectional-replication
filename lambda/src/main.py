import os
import boto3
from boto3.dynamodb.types import TypeDeserializer

serializer = TypeDeserializer()
destination_dynamo_table_id = os.getenv('DESTINATION_DYNAMODB_TABLE_ID')
destination_dynamo_region = os.getenv('DESTINATION_DYNAMODB_REGION')
destination_iam_role_arn = os.getenv('DESTINATION_IAM_ROLE_ARN')
sts_client = boto3.client('sts')
sts_session = sts_client.assume_role(RoleArn=destination_iam_role_arn, RoleSessionName='dynamodb-stream-lambda-session')
KEY_ID = sts_session['Credentials']['AccessKeyId']
ACCESS_KEY = sts_session['Credentials']['SecretAccessKey']
TOKEN = sts_session['Credentials']['SessionToken']
dyn_resource = boto3.resource('dynamodb',
    region_name=destination_dynamo_region,
    aws_access_key_id=KEY_ID,
    aws_secret_access_key=ACCESS_KEY,
    aws_session_token=TOKEN
)
        
def deserialize(data):
    if isinstance(data, list):
        return [deserialize(v) for v in data]

    if isinstance(data, dict):
        try:
            return serializer.deserialize(data)
        except TypeError:
            return {k: deserialize(v) for k, v in data.items()}
    else:
        return data


def handler(event, context): 
    data = deserialize(event)
    records = data.get('Records')
    print("processing records")
    for record in records:
        event_id = record.get('eventID')
        event_name = record.get('eventName')
        dynamodb_record = record.get('dynamodb')
        
        if event_name == "INSERT":
            #print("inserting into dynamo")
            insert_into_dynamodb(destination_dynamo_table_id, destination_dynamo_region, dynamodb_record, dyn_resource)
        elif event_name == "MODIFY":
            #print("modifying record in dynamo")
            modify_record_in_dynamodb(destination_dynamo_table_id, destination_dynamo_region, dynamodb_record, dyn_resource)
        elif event_name == "REMOVE":
            #print("removing from dynamo")
            delete_record_in_dynamodb(destination_dynamo_table_id, destination_dynamo_region, dynamodb_record, dyn_resource)

    print("done processing records")

def insert_into_dynamodb(destination_table_id, destination_table_region, record, dyn_resource=None):
    #print(f"dynamodb table: {destination_table_id}")
    #print(f"destination dynamodb region: {destination_table_region}")
    #print(f"record: {record}")

    new_image = record.get('NewImage')
    partition_key = new_image.get('partition_key')
    sort_key = new_image.get('sort_key')
    some_data = new_image.get('some_data')

    if dyn_resource is None:
        dyn_resource = boto3.resource('dynamodb', region_name=destination_dynamo_region)

    table = dyn_resource.Table(destination_dynamo_table_id)
    response = table.put_item(Item={
        'partition_key': partition_key,
        'sort_key': sort_key,
        'some_data': some_data
    })
    print(f"Put Item response: {response}")
    print(f"Put item ({partition_key}, {sort_key}) succeeded.")

def modify_record_in_dynamodb(destination_table_id, destination_table_region, record, dyn_resource=None):
    #print(f"dynamodb table: {destination_table_id}")
    #print(f"destination dynamodb region: {destination_table_region}")
    #print(f"record: {record}")

    new_image = record.get('NewImage')
    partition_key = new_image.get('partition_key')
    sort_key = new_image.get('sort_key')
    some_data = new_image.get('some_data')

    if dyn_resource is None:
        dyn_resource = boto3.resource('dynamodb', region_name=destination_dynamo_region)

    table = dyn_resource.Table(destination_dynamo_table_id)
    response = table.update_item(
        Key={
            'partition_key': partition_key,
            'sort_key': sort_key,
        },
        UpdateExpression="set some_data = :r",
        ExpressionAttributeValues={
            ':r': some_data,
        },
        ReturnValues="UPDATED_NEW"
    )
    print(f"Modify Item response: {response}")
    print(f"Modify item ({partition_key}, {sort_key}) succeeded.")

def delete_record_in_dynamodb(destination_table_id, destination_table_region, record, dyn_resource=None):
    #print(f"dynamodb table: {destination_table_id}")
    #print(f"destination dynamodb region: {destination_table_region}")
    #print(f"record: {record}")

    new_image = record.get('OldImage')
    partition_key = new_image.get('partition_key')
    sort_key = new_image.get('sort_key')

    if dyn_resource is None:
        dyn_resource = boto3.resource('dynamodb', region_name=destination_dynamo_region)

    table = dyn_resource.Table(destination_dynamo_table_id)
    response = table.delete_item(Key={
        'partition_key': partition_key,
        'sort_key': sort_key
    })
    print(f"Delete item response: {response}")
    print(f"Delete item ({partition_key}, {sort_key}) succeeded.")