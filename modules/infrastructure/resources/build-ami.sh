#!/bin/bash
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_PIPELINING=True
export AWS_REGION="${platform_aws_region}"
export LANG=C

ansible-playbook -i ~/primed-ami-inventory /usr/share/ansible/openshift-ansible/playbooks/aws/openshift-cluster/build_ami.yml -e @primed-ami-provisioning-vars.yml -vvv | tee ansible-$(date +%Y%m%d%H%M%S)-build_ami.log
