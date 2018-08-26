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

if [ -z $UPSTREAM ]; then
    ENABLE_REPOS="rhel-7-server-rpms,rhel-7-server-extras-rpms,rhel-7-fast-datapath-rpms,rhel-7-server-ansible-2.4-rpms"
    ENABLE_REPOS="$ENABLE_REPOS,rhel-7-server-ose-${openshift_major_version}-rpms"

    ansible all -i $HOME/inventory.yml -m redhat_subscription -a 'username=${rhn_username} password=${rhn_password} pool_ids=${rh_subscription_pool_id}'
    ansible all -i $HOME/inventory.yml -m rhsm_repository -a 'name="*" state=disabled'
    ansible all -i $HOME/inventory.yml -m rhsm_repository -a "name=$ENABLE_REPOS"
fi

ansible-playbook -i $HOME/inventory.yml /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml -vvv | tee ansible-$(date +%Y%m%d%H%M%S)-prerequisites.log
ansible-playbook -i $HOME/inventory.yml /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml -vvv | tee ansible-$(date +%Y%m%d%H%M%S)-deploy_cluster.log
