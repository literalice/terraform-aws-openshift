#!/bin/bash

sudo yum -y install ansible
ansible-playbook -i localhost, -c local ~/bastion-config-playbook.yaml
