#!/bin/bash

## us-east-1 to us-west-2 replication
echo "Replication from us-east-1 to us-west-2"
read -p "Press enter to write data into us-east-1"
export AWS_PROFILE=us-east-1; python3 scripts/write_data.py east

read -p "Press enter to get data count in us-east-1 and us-west-2"
export AWS_PROFILE=us-east-1; python3 scripts/get_data.py east
export AWS_PROFILE=us-west-2; python3 scripts/get_data.py west

read -p "Press enter to update data in us-east-1"
export AWS_PROFILE=us-east-1; python3 scripts/get_data_single.py east
export AWS_PROFILE=us-west-2; python3 scripts/get_data_single.py west
export AWS_PROFILE=us-east-1; python3 scripts/modify_data.py east

read -p "Press enter to read updated data in us-east-1 and us-west-2"
export AWS_PROFILE=us-east-1; python3 scripts/get_data_single.py east
export AWS_PROFILE=us-west-2; python3 scripts/get_data_single.py west

read -p "Press enter to delete data in us-east-1"
export AWS_PROFILE=us-east-1; python3 scripts/delete_data.py east

read -p "Press enter to get data count in us-east-1 and us-west-2"
export AWS_PROFILE=us-east-1; python3 scripts/get_data.py east
export AWS_PROFILE=us-west-2; python3 scripts/get_data.py west


## us-west-2 to us-east-1 replication
read -p "Press enter to start next test"
echo "Replication from us-west-2 to us-east-1"

read -p "Press enter to write data into us-west-2"
export AWS_PROFILE=us-west-2; python3 scripts/write_data.py west

read -p "Press enter to get data count in us-west-2 and us-east-1"
export AWS_PROFILE=us-west-2; python3 scripts/get_data.py west
export AWS_PROFILE=us-east-1; python3 scripts/get_data.py east

read -p "Press enter to update data in us-west-2"
export AWS_PROFILE=us-west-2; python3 scripts/get_data_single.py west
export AWS_PROFILE=us-east-1; python3 scripts/get_data_single.py east
export AWS_PROFILE=us-west-2; python3 scripts/modify_data.py west

read -p "Press enter to read updated data in us-west-2 and us-east-1"
export AWS_PROFILE=us-west-2; python3 scripts/get_data_single.py west
export AWS_PROFILE=us-east-1; python3 scripts/get_data_single.py east

read -p "Press enter to delete data in us-west-2"
export AWS_PROFILE=us-west-2; python3 scripts/delete_data.py west

read -p "Press enter to get data count in us-west-2 and us-east-1"
export AWS_PROFILE=us-west-2; python3 scripts/get_data.py west
export AWS_PROFILE=us-east-1; python3 scripts/get_data.py east

echo "end of tests"