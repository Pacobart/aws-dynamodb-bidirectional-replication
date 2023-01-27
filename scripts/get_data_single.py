import boto3
import sys

def get_item(table_id, table_region, partition_key, sort_key, dyn_resource=None):
    """
    Gets all items from the table.
    """
    if dyn_resource is None:
        dyn_resource = boto3.resource('dynamodb', region_name=table_region)

    table = dyn_resource.Table(table_id)
    response = table.get_item(
        Key={
            'partition_key': partition_key,
            'sort_key': sort_key
        }
    )

    data = response['Item']

    return data


if __name__ == '__main__':
    if sys.argv[1:][0] == "east":
        dynamodb_table_id = "dynamo-us-east-1"
        dynamodb_table_region = "us-east-1"
    elif sys.argv[1:][0] == "west":
        dynamodb_table_id = "dynamo-us-west-2"
        dynamodb_table_region = "us-west-2"
    item = get_item(dynamodb_table_id, dynamodb_table_region, 7, 9)
    print(f"item in {dynamodb_table_id}: {item}")
                