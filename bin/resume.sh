#!/bin/bash

asg_names="$(terraform output platform_name)-bastion $(terraform output platform_name)-master $(terraform output platform_name)-compute"

for asg_name in $asg_names; do

  compute_ids=$(aws ec2 describe-instances --filters "Name=tag:aws:autoscaling:groupName,Values=${asg_name}" --query "Reservations[].Instances[].[InstanceId]" --output text)

  for compute_id in $compute_ids; do
    echo return as healty: $compute_id : $asg_name

    aws ec2 start-instances --instance-ids $compute_id
    aws autoscaling set-instance-health --instance-id $compute_id --health-status Healthy
  done

  aws autoscaling resume-processes --auto-scaling-group-name ${asg_name} --scaling-processes Terminate
done

