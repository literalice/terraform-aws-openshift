.PHONEY: all network platform domain install destroy

all: domain

network:
	@echo "Builds network for OpenShift"
	@terraform apply -target module.openshift_network

platform: network
	@echo "Builds instances for OpenShift"
	@terraform apply -target module.openshift_platform

domain: platform
	@echo "Builds domain zone for OpenShift"
	@terraform apply -target module.openshift_domain

install:
	@terraform apply

destroy:
	@echo "Destroy domain settings ..."
	@terraform destroy -target module.openshift_domain
	@echo "Destroy platform resources ..."
	@terraform destroy -target module.openshift_platform
	@echo "Destroy platform network resources ..."
	@terraform destroy -target module.openshift_network
