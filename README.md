# Terraform OpenShift Container Platform Module

Builds OpenShift Reference archtecture on AWS.

Currently, It uses OCP(OpenShift Container Platform), not OpenShift Origin.

OpenShift Origin will be supported in future.

## Prerequisites

* You need to get access of Gold Images of Red Hat Atomic Host through the Red Hat Cloud Access program. See also https://access.redhat.com/articles/2962171

## Creates a cluster

You can set-up a cluster using [the example platform](/example/ocp/) project.

```bash
cd ./example/ocp

# Use make command and input values requested in the interaction.
make init
make

#
# public_dns_nameservers = [
#     ns-xxx.awsdns-xx.org,
#     ns-xxx.awsdns-xx.co.uk,
#     ns-xxx.awsdns-xx.com,
#     ns-xxx.awsdns-xx.net
# ]
#

# You need to set up the domain names for access the cluster.
# You can set the name servers in output provided by the `make` command as NS record on your name server.
# See also https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingNewSubdomain.html

make install

# You can access the master of the cluster.
```

### direnv
Instead of inputing values in interaction, you can use [direnv](https://github.com/direnv/direnv) and .envrc file for providing configuration.

```.envrc
# AWS access
export AWS_DEFAULT_REGION=ap-northeast-1
export AWS_PROFILE=xxxx

# Initialize backend for a building cluster's state
export TF_CLI_ARGS_init="-backend-config='bucket=sample-platform-setting'"
export TF_CLI_ARGS_init="$TF_CLI_ARGS_init -backend-config='key=state'"
export TF_CLI_ARGS_init="$TF_CLI_ARGS_init -backend-config='region=${AWS_DEFAULT_REGION}'"

# The name of the cluster that is used for tagging some resources
export TF_VAR_platform_name=sample-platform

# AWS key pair that is used for instances of the cluster includes the bastion
export TF_VAR_key_pair_public_key_path="${HOME}/.ssh/sample-platform.pub"
export TF_VAR_key_pair_private_key_path="${HOME}/.ssh/sample-platform"

# Red Hat Network credential for registration system of the OpenShift Container Platform cluster
export TF_VAR_rhn_username="xxx@example.com"
export TF_VAR_rhn_password="xxxxxxxxxxx"

# Red Hat subscription pool id for OpenShift Container Platform
export TF_VAR_rh_subscription_pool_id="xxxxxxxx"

# Public DNS subdomain for access to services served in the cluster
export TF_VAR_platform_default_subdomain=sample-platform.example.com
```