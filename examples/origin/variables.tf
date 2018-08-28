variable "platform_name" {}

variable "key_pair_private_key_path" {
  default = ""
}

variable "operator_cidrs" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "public_cidrs" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "bastion_instance_type" {
  default = "m4.large"
}

variable "bastion_spot_price" {
  default = "0.1"
}

variable "master_count" {
  default = 1
}

variable "master_instance_type" {
  default = "m4.large"
}

variable "master_spot_price" {
  default = "0.1"
}

variable "compute_node_count" {
  default = 2
}

variable "compute_node_instance_type" {
  default = "m4.large"
}

variable "compute_node_spot_price" {
  default = "0.1"
}

variable "platform_domain" {
  default = ""
}

variable "platform_domain_administrator_email" {
  default = ""
}

variable "image_id" {}
