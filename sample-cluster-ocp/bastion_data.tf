data "aws_instance" "bastion" {
  instance_id = "${module.openshift_platform.bastion_instance_id}"
}