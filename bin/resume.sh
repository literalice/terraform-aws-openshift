#!/bin/bash

asg_names="${TF_VAR_platform_name}-master ${TF_VAR_platform_name}-infra-node ${TF_VAR_platform_name}-compute-node"

for asg_name in $asg_names; do

  compute_ids=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${asg_name}" --query "Reservations[].Instances[].[InstanceId]" --output text)

  for compute_id in $compute_ids; do
    echo return as healty: $compute_id : $asg_name

    aws ec2 start-instances --instance-ids $compute_id
    aws autoscaling set-instance-health --instance-id $compute_id --health-status Healthy
  done

  aws autoscaling resume-processes --auto-scaling-group-name ${asg_name} --scaling-processes Terminate
done

