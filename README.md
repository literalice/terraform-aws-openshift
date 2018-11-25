# Terraform OpenShift Container Platform Module

Builds OpenShift reference archtecture on AWS.

Now it supports OCP(working for OKD).

## Prerequisites

* You need to create [Public Route53 Zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html) for your platform domain. if your master domain is `mycluster.example.com`, a Public Route53 Zone named `mycluster.example.com` is required.

If you are building a OCP cluster,

* you need to know a subscription pool id for OCP.
* you need to get access of Gold Images of Red Hat Atomic Host through the Red Hat Cloud Access program. See also https://access.redhat.com/articles/2962171

## Creates a cluster

### Sets terraform variables for creating openshift cluster.

See: [OCP examples](/examples/ocp/terraform.tfvars.example)

### Starts a cluster building

```bash
terraform plan -var-file=xxx.tfvars
terraform apply -var-file=xxx.tfvars
```

### Accesses your cluster's admin console.

Once your cluster is launched successfully, you can access your cluster's admin console.

`make console`

## Tips

### SSH to Bastion

```
make ssh
```
