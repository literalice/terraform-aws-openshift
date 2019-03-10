.PHONEY: all install destroy

key:
	@terraform output platform_private_key > /tmp/.openshift-`terraform output platform_name`.key
	@chmod 600 /tmp/.openshift-`terraform output platform_name`.key

sshspec:
	@terraform output bastion_ssh_spec

ssh: key
	@ssh `terraform output bastion_ssh_spec` -i /tmp/.openshift-`terraform output platform_name`.key

console:
	@open `terraform output master_public_url`
