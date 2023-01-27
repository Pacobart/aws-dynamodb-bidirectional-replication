import boto3
import sys

def write_data_to_dynamodb_table(table_id, table_region, key_count, item_size, dyn_resource=None):
    """
    Writes test data to the table.
    """
    if dyn_resource is None:
        dyn_resource = boto3.resource('dynamodb', region_name=table_region)

    table = dyn_resource.Table(table_id)
    some_data = 'X' * item_size

    for partition_key in range(1, key_count + 1):
        for sort_key in range(1, key_count + 1):
            table.put_item(Item={
                'partition_key': partition_key,
                'sort_key': sort_key,
                'some_data': some_data
            })
            print(f"Put item ({partition_key}, {sort_key}) succeeded.")


if __name__ == '__main__':
    write_key_count = 10
    write_item_size = 1000
    if sys.argv[1:][0] == "east":
        dynamodb_table_id = "dynamo-us-east-1"
        dynamodb_table_region = "us-east-1"
    elif sys.argv[1:][0] == "west":
        dynamodb_table_id = "dynamo-us-west-2"
        dynamodb_table_region = "us-west-2"
    print(f"Writing {write_key_count*write_key_count} items to the table {dynamodb_table_id}. "
          f"Each item is {write_item_size} characters.")
    write_data_to_dynamodb_table(dynamodb_table_id, dynamodb_table_region, write_key_count, write_item_size)