variable "platform_name" {}

variable "platform_vpc_id" {}

variable "public_subnet_ids" {
  type = "list"
}

variable "private_subnet_ids" {
  type = "list"
}

variable "operator_cidrs" {
  type = "list"
}

variable "public_cidrs" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "platform_domain" {
  default = ""
}

variable "key_pair_private_key" {
  default = ""
}

variable "openshift_major_version" {
  default = ""
}

variable "upstream" {
  default = true
}

variable "rhn_username" {}
variable "rhn_password" {}
variable "rh_subscription_pool_id" {}

variable "master_count" {}

variable "compute_node_count" {}

variable "bastion_instance_type" {
  default = "t2.medium"
}

variable "master_instance_type" {
  default = "m4.large"
}

variable "compute_node_instance_type" {
  default = "m4.xlarge"
}

variable "bastion_spot_price" {
  default = "0.1"
}

variable "master_spot_price" {
  default = "0.1"
}

variable "compute_node_spot_price" {
  default = "0.1"
}

variable "node_image_id" {}

variable "bastion_image_id" {}
