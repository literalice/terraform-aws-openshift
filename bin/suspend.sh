#!/bin/bash

asg_names="$(terraform output platform_name)-bastion $(terraform output platform_name)-master $(terraform output platform_name)-compute"

for asg_name in $asg_names; do
  aws autoscaling suspend-processes --auto-scaling-group-name ${asg_name} --scaling-processes Terminate

  compute_ids=$(aws ec2 describe-instances --filters "Name=tag:aws:autoscaling:groupName,Values=${asg_name}" --query "Reservations[].Instances[].[InstanceId]" --output text)

  if [ -n ${compute_ids} ]; then
    aws ec2 stop-instances --instance-ids $compute_ids
  fi
done

