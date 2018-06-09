#!/bin/bash

asg_names="${TF_VAR_platform_name}-master ${TF_VAR_platform_name}-infra-node ${TF_VAR_platform_name}-compute-node"

for asg_name in $asg_names; do
  aws autoscaling suspend-processes --auto-scaling-group-name ${asg_name} --scaling-processes Terminate

  compute_ids=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${asg_name}" --query "Reservations[].Instances[].[InstanceId]" --output text)

  aws ec2 stop-instances --instance-ids $compute_ids
#   for compute_id in $compute_ids; do
#     echo stopping instance ...: $compute_id : $asg_name
#   done
done

