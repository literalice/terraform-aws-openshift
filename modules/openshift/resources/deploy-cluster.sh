#!/bin/bash

export LANG=C
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_FORKS=5
export ANSIBLE_PIPELINING=True

export AWS_REGION="${platform_aws_region}"

ocinventory -cluster "${platform_name}" -inventory $HOME/template-inventory.yaml > $HOME/inventory.yaml

if [ -z $USE_COMMUNITY ]; then
    echo "It's a OCP"
    ansible-playbook -i $HOME/inventory.yaml $HOME/node-repos-playbook.yaml || { echo "Error on register repos" ; exit 1 ; }
else
    echo "It's a OKD"
    ansible all -i $HOME/inventory.yaml -m yum -a 'name=wget,git,net-tools,bind-utils,yum-utils,iptables-services,bridge-utils,bash-completion,kexec-tools,sos,psacct,atomic state=present'
    ansible all -i $HOME/inventory.yaml -m yum -a 'name=docker-1.13.1 state=present'
    ansible all -i $HOME/inventory.yaml -m systemd -a 'name=docker state=started enabled=yes'
fi

cd /usr/share/ansible/openshift-ansible
ansible-playbook -i $HOME/inventory.yaml playbooks/prerequisites.yml || { echo "Error on prerequisites" ; exit 1 ; }
ansible-playbook -i $HOME/inventory.yaml playbooks/deploy_cluster.yml || { echo "Error on deploying cluster" ; exit 1 ; }