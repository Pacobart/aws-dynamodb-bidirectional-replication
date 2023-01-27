import boto3
import sys

def delete_data_from_dynamodb_table(table_id, table_region, key_count, dyn_resource=None):
    '''
    Deletes all data from dynamodb table
    '''
    if dyn_resource is None:
        dyn_resource = boto3.resource('dynamodb', region_name=table_region)
        table = dyn_resource.Table(table_id)

        for partition_key in range(1, key_count + 1):
            for sort_key in range(1, key_count + 1):
                table.delete_item(Key={
                    'partition_key': partition_key,
                    'sort_key': sort_key,
                })
                print(f"Delete item ({partition_key}, {sort_key}) succeeded.")

if __name__ == '__main__':
    write_key_count = 10
    if sys.argv[1:][0] == "east":
        dynamodb_table_id = "dynamo-us-east-1"
        dynamodb_table_region = "us-east-1"
    elif sys.argv[1:][0] == "west":
        dynamodb_table_id = "dynamo-us-west-2"
        dynamodb_table_region = "us-west-2"
    print(f"Deleting {write_key_count*write_key_count} items from the table {dynamodb_table_id}.")
    delete_data_from_dynamodb_table(dynamodb_table_id, dynamodb_table_region, write_key_count)