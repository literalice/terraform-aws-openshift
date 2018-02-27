.PHONEY: all network platform domain install destroy

all: domain

init:
	@terraform init

network:
	@echo "Builds network for OpenShift"
	@terraform apply -target module.openshift_platform.module.network

platform: network
	@echo "Builds infrastructure for OpenShift"
	@terraform apply -target module.openshift_platform.module.infrastructure

domain: platform
	@echo "Builds domain zone for OpenShift"
	@terraform apply -target module.openshift_platform.module.domain

install:
	@terraform apply

destroy:
	@echo "Destroy domain settings ..."
	@terraform destroy -target module.openshift_platform.module.domain
	@echo "Destroy infrastructure resources ..."
	@terraform destroy -target module.openshift_platform.module.infrastructure
	@echo "Destroy platform network resources ..."
	@terraform destroy -target module.openshift_platform.module.network
