#!/bin/bash

while ! type "ocinventory" > /dev/null 2>&1 || ! type "ansible-playbook" > /dev/null 2>&1 
do 
    echo -n "#" 
    sleep 1 
done

export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_FORKS=20
# export ANSIBLE_PIPELINING=True

export AWS_REGION="${platform_aws_region}"

ocinventory -cluster "${platform_name}" -inventory /etc/oc-inventory.yml > $HOME/inventory.yml
ansible-playbook -i $HOME/inventory.yml /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml
