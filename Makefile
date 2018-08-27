.PHONEY: all network infrastructure domain install destroy

all: domain

init:
	@cd examples/$(CLUSTER_CONFIG); terraform init

refresh:
	@cd examples/$(CLUSTER_CONFIG); terraform refresh

test:
	@cd examples/$(CLUSTER_CONFIG); terraform apply -target null_resource.openshift_check

key:
	@cd examples/$(CLUSTER_CONFIG); terraform output -module openshift_platform platform_private_key

sshspec:
	@cd examples/$(CLUSTER_CONFIG); terraform output -module openshift_platform bastion_ssh

csr:
	@cd examples/$(CLUSTER_CONFIG); terraform output -module openshift_platform.domain certificate_pem

dns-nameservers:
	@cd examples/$(CLUSTER_CONFIG); terraform output -module openshift_platform.domain public_dns_nameservers

master-url:
	@cd examples/$(CLUSTER_CONFIG); terraform output -module openshift_platform.infrastructure master_url

network:
	@echo "Builds network for OpenShift"
	@cd examples/$(CLUSTER_CONFIG); terraform apply -target module.openshift_platform.module.network

infrastructure: network
	@echo "Builds infrastructure for OpenShift"
	@cd examples/$(CLUSTER_CONFIG); terraform apply -target module.openshift_platform.module.infrastructure
	@cd examples/$(CLUSTER_CONFIG); terraform output -module openshift_platform.infrastructure

domain: infrastructure
	@echo "Builds domain zone for OpenShift"
	@cd examples/$(CLUSTER_CONFIG); terraform apply -target module.openshift_platform.module.domain

install:
	@cd examples/$(CLUSTER_CONFIG); terraform apply

destroy-network:
	@echo "Destroy platform network resources ..."
	@cd examples/$(CLUSTER_CONFIG); terraform destroy -target module.openshift_platform.module.network

destroy-infrastructure:
	@echo "Destroy platform infrastructure resources ..."
	@cd examples/$(CLUSTER_CONFIG); terraform destroy -target module.openshift_platform.module.infrastructure

destroy-domain:
	@echo "Destroy platform domain resources ..."
	@cd examples/$(CLUSTER_CONFIG); terraform destroy -target module.openshift_platform.module.domain

destroy:
	@echo "Destroy domain settings ..."
	@cd examples/$(CLUSTER_CONFIG); terraform destroy -target module.openshift_platform.module.domain
	@echo "Destroy infrastructure resources ..."
	@cd examples/$(CLUSTER_CONFIG); terraform destroy -target module.openshift_platform.module.infrastructure
	@echo "Destroy platform network resources ..."
	@cd examples/$(CLUSTER_CONFIG); terraform destroy -target module.openshift_platform.module.network
