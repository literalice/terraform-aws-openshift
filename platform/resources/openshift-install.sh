#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False
export AWS_REGION="${platform_aws_region}"
ocinventory -cluster "${platform_name}" -inventory /etc/oc-inventory.yml > $HOME/inventory.yml
ansible-playbook -i $HOME/inventory.yml /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml
