#!/bin/bash

while ! type "ocinventory" > /dev/null 2>&1 || ! type "ansible-playbook" > /dev/null 2>&1 
do 
    echo -n "#" 
    sleep 1 
done

export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_FORKS=5
export ANSIBLE_PIPELINING=True

export AWS_REGION="${platform_aws_region}"

ocinventory -cluster "${platform_name}" -inventory $HOME/template-inventory.yml > $HOME/inventory.yml

export LANG=C

ansible all -i $HOME/inventory.yml -a 'subscription-manager register --username=${rhn_username} --password=${rhn_password}'
ansible all -i $HOME/inventory.yml -a 'subscription-manager attach --pool=${rh_subscription_pool_id}'
ansible all -i $HOME/inventory.yml -a 'subscription-manager repos --disable="*"'
ansible all -i $HOME/inventory.yml -a 'subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-fast-datapath-rpms" --enable="rhel-7-server-ansible-2.4-rpms"'
ansible all -i $HOME/inventory.yml -a 'subscription-manager repos --enable="rhel-7-server-ose-${openshift_major_version}-rpms"'

ansible-playbook -i $HOME/inventory.yml /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml
ansible-playbook -i $HOME/inventory.yml /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml
