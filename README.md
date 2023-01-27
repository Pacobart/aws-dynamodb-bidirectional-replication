#dynamodb-across-account-replication

# Overview

Deploys dynamodb table and lambda into 2 separate accounts in separate regions (us-east-1 and us-west-2)
Data will sync between both. This supports insert, update and delete.

# Setup
Create 2 aws profiles in `~/.aws/credentials` with access keys named `us-east-1` and `us-west-2`

# Tests covered

- writing new data from A to B
- deleting data from A to B
- modify data in A to B
- writing new data from B to A
- deleting data from B to A
- modify data in B to A

## Test replication
1. Deploy terraform with `terraform apply -auto-approve`
2. Run `./run_test.sh`


## Notes

Change billing mode to PAY_PER_REQUEST. If using provisioned some records won't be written
