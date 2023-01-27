import boto3
import sys

def get_all_items(table_id, table_region, dyn_resource=None):
    """
    Gets all items from the table.
    """
    if dyn_resource is None:
        dyn_resource = boto3.resource('dynamodb', region_name=table_region)

    table = dyn_resource.Table(table_id)
    response = table.scan()
    data = response['Items']

    while 'LastEvaluatedKey' in response:
        response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
        data.extend(response['Items'])

    return data


if __name__ == '__main__':
    if sys.argv[1:][0] == "east":
        dynamodb_table_id = "dynamo-us-east-1"
        dynamodb_table_region = "us-east-1"
    elif sys.argv[1:][0] == "west":
        dynamodb_table_id = "dynamo-us-west-2"
        dynamodb_table_region = "us-west-2"
    items = get_all_items(dynamodb_table_id, dynamodb_table_region)
    print(f"items in {dynamodb_table_id}: {len(items)}")
                