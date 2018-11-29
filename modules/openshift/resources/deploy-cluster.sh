#!/bin/bash

export LANG=C
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_FORKS=5
export ANSIBLE_PIPELINING=True

export AWS_REGION="${platform_aws_region}"

ocinventory -cluster "${platform_name}" -inventory $HOME/template-inventory.yaml > $HOME/inventory.yaml

ansible-playbook -i $HOME/inventory.yaml $HOME/node-config-playbook.yaml || { echo "Error on register repos" ; exit 1 ; }

cd /usr/share/ansible/openshift-ansible
ansible-playbook -i $HOME/inventory.yaml playbooks/prerequisites.yml || { echo "Error on prerequisites" ; exit 1 ; }
ansible-playbook -i $HOME/inventory.yaml playbooks/deploy_cluster.yml || { echo "Error on deploying cluster" ; exit 1 ; }

cd ~
ansible-playbook -i $HOME/inventory.yaml $HOME/openshift-applier/openshift-policies/config.yml || { echo "Error on applier" ; exit 1 ; }
