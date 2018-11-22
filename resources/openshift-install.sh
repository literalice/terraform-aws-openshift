#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_FORKS=5
export ANSIBLE_PIPELINING=True

export AWS_REGION="${platform_aws_region}"

ocinventory -cluster "${platform_name}" -inventory $HOME/template-inventory.yml > $HOME/inventory.yml

export LANG=C

if [ -z $UPSTREAM ]; then
    echo "It's a OCP"
else
    echo "It's a OKD"
    ansible all -i $HOME/inventory.yml -m yum -a 'name=wget,git,net-tools,bind-utils,yum-utils,iptables-services,bridge-utils,bash-completion,kexec-tools,sos,psacct,atomic state=present'
    ansible all -i $HOME/inventory.yml -m yum -a 'name=docker-1.13.1 state=present'
    ansible all -i $HOME/inventory.yml -m systemd -a 'name=docker state=started enabled=yes'
fi

ansible-playbook -i $HOME/inventory.yml /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml -vvv | tee ansible-$(date +%Y%m%d%H%M%S)-prerequisites.log
ansible-playbook -i $HOME/inventory.yml /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml -vvv | tee ansible-$(date +%Y%m%d%H%M%S)-deploy_cluster.log
