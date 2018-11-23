sshspec:
	@echo `terraform output -module openshift_infra bastion_ssh_user`@`terraform output -module openshift_infra bastion_endpoint`

key:
	@terraform output -module openshift_infra platform_private_key > /tmp/.$(TF_VAR_platform_name).infra.key
	@chmod 600 /tmp/.$(TF_VAR_platform_name).infra.key

ssh: key
	@ssh `make sshspec` -i /tmp/.$(TF_VAR_platform_name).infra.key
