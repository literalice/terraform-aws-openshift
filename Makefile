.PHONEY: all network infrastructure domain install destroy

all: domain

init:
	@terraform init examples/$(CLUSTER_EXAMPLE)

network:
	@echo "Builds network for OpenShift"
	@terraform apply -target module.openshift_platform.module.network examples/$(CLUSTER_EXAMPLE)

infrastructure: network
	@echo "Builds infrastructure for OpenShift"
	@terraform apply -target module.openshift_platform.module.infrastructure examples/$(CLUSTER_EXAMPLE)

domain: infrastructure
	@echo "Builds domain zone for OpenShift"
	@terraform apply -target module.openshift_platform.module.domain examples/$(CLUSTER_EXAMPLE)

install:
	@terraform apply examples/$(CLUSTER_EXAMPLE)

destroy-network:
	@echo "Destroy platform network resources ..."
	@terraform destroy -target module.openshift_platform.module.network examples/$(CLUSTER_EXAMPLE)

destroy-infrastructure:
	@echo "Destroy platform infrastructure resources ..."
	@terraform destroy -target module.openshift_platform.module.infrastructure examples/$(CLUSTER_EXAMPLE)

destroy-domain:
	@echo "Destroy platform domain resources ..."
	@terraform destroy -target module.openshift_platform.module.domain examples/$(CLUSTER_EXAMPLE)

destroy:
	@echo "Destroy domain settings ..."
	@terraform destroy -target module.openshift_platform.module.domain examples/$(CLUSTER_EXAMPLE)
	@echo "Destroy infrastructure resources ..."
	@terraform destroy -target module.openshift_platform.module.infrastructure examples/$(CLUSTER_EXAMPLE)
	@echo "Destroy platform network resources ..."
	@terraform destroy -target module.openshift_platform.module.network examples/$(CLUSTER_EXAMPLE)
