# OpenShift Terraform Module

Builds OpenShift Reference archtecture on AWS.

Currently, It uses OCP(OpenShift Container Platform), not OpenShift origin.

OpenShift origin will be supported in future.

## Prerequisites

* You need to get access of Gold Images of Red Hat Atomic Host through the Red Hat Cloud Access program. See also https://access.redhat.com/articles/2962171
* You need to have name servers for your cluster public domains.
* You need to provision a certificate for wildcard domain of your default public subdomain (ex. `*.public-app.example.com`) in ACM.

## Sample platform

You can see usage of these modules in [the sample platform](/sample-cluster-ocp/)

## OpenShift Network Module

It sets up subnets and gateways for your OpenShift Cluster on AWS.

### Parameters

| Name | Info |
|:-----|:-----|
| platform_name | Cluster identifier |
| zones | AZs where the cluster is deployed |
| platform_cidr |      |
| private_cidrs | Cidrs where the instances of the cluster is deployed |
| public_cidrs| Cidrs where the public LB of the cluster is deployed |
| operator_cidrs| Cidrs from which the cluster operators can access to the cluster master |
| public_access_cidrs |      |

### Example

```terraform
module "openshift_network" {
  source = "../network"

  platform_name = "foobar"
  platform_cidr = "10.0.0.0/16"
  private_cidrs = ["10.0.0.0/19", "10.0.32.0/19"]
  operator_cidrs = ["", ""]
  public_access_cidrs = ["0.0.0.0/0"]
}
```

### OpenShift Platform Module

It sets up instances(bastion, master, worker) and load balancers on AWS.

#### Example

```terraform
module "openshift_platform" {
  source = "../platform"

  platform_name = "${var.platform_name}"
  platform_vpc_id = "${module.openshift_network.platform_vpc_id}"
  key_pair_public_key = "${var.key_pair_public_key}"
  key_pair_private_key = "${file(var.key_pair_private_key_path)}"

  public_subnet_ids = ["${module.openshift_network.public_subnet_ids}"]
  private_subnet_ids = ["${module.openshift_network.private_subnet_ids}"]

  operator_cidrs = ["${var.operator_cidrs}"]
  public_access_cidrs = ["${var.public_access_cidrs}"]

  rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
  rhn_username = "${var.rhn_username}"
  rhn_password = "${var.rhn_password}"

  master_dns_name = "${var.master_dns_name}"
  master_public_dns_name = "${var.master_public_dns_name}"
  platform_default_subdomain = "${var.platform_dns_name}"

  infra_node_count = "${var.infra_node_count}"
  master_count = "${var.master_count}"
}
```

### OpenShift Domain Module

It sets up domains for your cluster on AWS.

#### Example

```
module "openshift_domain" {
  source = "../domain"

  platform_vpc_id = "${module.openshift_network.platform_vpc_id}"
  platform_name = "${var.platform_name}"
  platform_dns_name = "${var.platform_dns_name}"
  platform_private_dns_name = "${var.platform_private_dns_name}"
  bastion_ip = "${data.aws_instance.bastion.public_ip}"
  master_public_dns_name = "${var.master_public_dns_name}"
  master_public_lb_arn = "${module.openshift_platform.master_public_lb_arn}"
  master_dns_name = "${var.master_dns_name}"
  master_lb_name = "${module.openshift_platform.master_lb_name}"
  platform_public_lb_arn = "${module.openshift_platform.platform_public_lb_arn}"
}
```

### Sets up OpenShift Cluster

After set up infrastructure, you need to run ansible installer on the bastion instances.

```bash
 $ ssh ec2-user@bastion.<your-cluster-public-domain>
 $ /etc/oc-install.sh
```
