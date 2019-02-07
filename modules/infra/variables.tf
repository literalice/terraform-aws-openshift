variable "platform_name" {}

variable "platform_vpc_id" {}

variable "public_subnet_ids" {
  type    = "list"
  default = []
}

variable "private_subnet_ids" {
  type    = "list"
  default = []
}

variable "operator_cidrs" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "public_cidrs" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "use_spot" {
  default = false
}

variable "use_community" {
  default = false
}

variable "use_specific_base_image" {
    default = false
}

variable "specific_base_image_id" {
    default = ""
}

variable "specific_base_image_root_device_name" {
    default = ""
}

variable "master_count" {
  default = 1
}

variable "infra_node_count" {
  default = 0
}

variable "compute_node_count" {
  default = 3
}

variable "master_instance_type" {
  default = "m4.xlarge"
}

variable "infra_node_instance_type" {
  default = "m4.large"
}

variable "compute_node_instance_type" {
  default = "m4.large"
}
