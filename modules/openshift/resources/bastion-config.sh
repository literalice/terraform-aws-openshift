#!/bin/bash

if [ -z $USE_COMMUNITY ]; then
    echo "It's a OCP"
    sudo yum -y install ansible
else
    echo "It's a OKD"
    sudo yum -y --enablerepo=epel install ansible pyOpenSSL
fi

ansible-playbook -i localhost, -c local ~/bastion-config-playbook.yaml
