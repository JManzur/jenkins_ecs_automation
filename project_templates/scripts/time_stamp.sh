#!/bin/bash
# Used by: ecr-push.tf
# Generate correct timestamp - used instead of terraform timestamp() or formatdate("YYYYMMDDHHmm", timestamp())

time_stamp=$(date +%Y%m%d%H%M)
echo '{ "time_stamp": "'"$time_stamp"'" }'