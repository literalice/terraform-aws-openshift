# Terraform OpenShift Container Platform Module

Builds OpenShift reference archtecture on AWS.

It supports OCP and Origin.

## Prerequisites

If you are building a OCP cluster, 

* you need to know a subscription pool id for OCP.
* you need to get access of Gold Images of Red Hat Atomic Host through the Red Hat Cloud Access program. See also https://access.redhat.com/articles/2962171

## Creates a cluster

You can set-up a cluster using [the example origin platform](/example/origin/) or [the example OCP platform](/example/origin/) project.

### Selects Origin or OCP

If you are building a Origin cluster, use [the example origin platform](/example/origin/) project.

```bash
cd ./example/origin
```

If you are building a OCP cluster, use [the example OCP platform](/example/ocp/) project.

```bash
cd ./example/ocp
```

### Builds infrastructure on AWS for installing OpenShift.

Use make command and input values requested in the interaction.

```bash
make init
make
```

You will be asked some parameters for configuring the cluster infrastructure. See also [direnv](#direnv).

### Public DNS setting

You need to set up the domain names for install and access the cluster.

As a result of above commands, you should got the output:

```
public_dns_nameservers = [
    ns-xxx.awsdns-xx.org,
    ns-xxx.awsdns-xx.co.uk,
    ns-xxx.awsdns-xx.com,
    ns-xxx.awsdns-xx.net
]
```

You can set the name servers in a NS record of your name server for delegation.

See also https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingNewSubdomain.html

### Install OpenShift on the infrastructure

Once the DNS setting is active, you can install OpenShift using the command:

```
make install
```

After that, you can access the master of the cluster via URL provided as output of the `make install` command.

### Limitations

If you have some errors on running the above commands, please retry after a while.

## direnv
Instead of inputing values in interaction, you can use [direnv](https://github.com/direnv/direnv) and .envrc file for providing configuration.

```.envrc
# AWS access
export AWS_DEFAULT_REGION=ap-northeast-1
export AWS_PROFILE=xxxx

# The name of the cluster that is used for tagging some resources
export TF_VAR_platform_name=sample-platform

# AWS key pair that is used for instances of the cluster includes the bastion
export TF_VAR_key_pair_private_key_path="${HOME}/.ssh/sample-platform"

# Red Hat Network credential for registration system of the OpenShift Container Platform cluster
export TF_VAR_rhn_username="xxx@example.com"
export TF_VAR_rhn_password="xxxxxxxxxxx"

# Red Hat subscription pool id for OpenShift Container Platform
export TF_VAR_rh_subscription_pool_id="xxxxxxxx"

# Public DNS subdomain for access to services served in the cluster
export TF_VAR_platform_default_subdomain=sample-platform.example.com
```