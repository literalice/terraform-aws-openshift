# Terraform OpenShift Container Platform Module

Builds OpenShift reference architecture on AWS.

It supports OCP and OKD

## Prerequisites

If you want to use a custom domain for your OpenShift platform, 

* You need to create [Public Route53 Zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html) for your platform domain. If your master domain is `mycluster.example.com`, a Public Route53 Zone named `mycluster.example.com` is required.

When you use the nip.io wildcard domain, you don't have to prepare public dns settings. See [a example](/examples/nip).

If you are building an OCP cluster,

* you need to know a subscription pool id for OCP.
* you need to get access to Gold Images of Red Hat Atomic Host through the Red Hat Cloud Access program. See also https://access.redhat.com/articles/2962171

## Creates a cluster

### Sets terraform variables for creating openshift cluster.

OCP: [OCP examples](/examples/ocp/terraform.tfvars.example)

OKD: [OKD examples](/examples/nip/terraform.tfvars.example)

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

### Suspend / Resume instances

Only for on-demand instances (not spot instances)

```bash
# suspend
./bin/suspend.sh

# resume
./bin/resume.sh
```
