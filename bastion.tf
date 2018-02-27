data "aws_instance" "bastion" {
  instance_id = "${module.infrastructure.bastion_instance_id}"
}