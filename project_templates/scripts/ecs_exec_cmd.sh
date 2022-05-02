#!/bin/bash
# You can use this script to access the ecs fargate container
# Session Manager plugin for the AWS CLI is needed

# Hard-coded variables - (change as required)
AWS_REG=us-east-1
ECS_CLUSTER=demo-cluster
CONTAINER_NAME=flask-demo

if [[ $# -ne 1 ]] ;
    then
        echo 'Usage: ./ecs_exec_cmd.sh "{TASK_ID}"'
        echo 'Example: ./ecs_exec_cmd.sh 35e09a0b9eca4562b5a2bac1386f7cea'
        exit 1
    else
        aws ecs execute-command \
        --region $AWS_REG \
        --cluster $ECS_CLUSTER \
        --task $1 \
        --container $CONTAINER_NAME \
        --command "/bin/bash" --interactive
fi