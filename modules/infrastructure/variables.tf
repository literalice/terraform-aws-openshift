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

variable "public_access_cidrs" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "master_public_dns_name" {
  default = ""
}

variable "platform_default_subdomain" {
  default = ""
}

variable "platform_secure_listener" {
  default = false
}

variable "key_pair_private_key" {
  default = ""
}

variable "openshift_major_version" {
  default = "3.9"
}

variable "openshift_cluster_admin_users" {
  type    = "list"
  default = ["admin"]
}

variable "upstream" {
  default = true
}

variable "rhn_username" {}
variable "rhn_password" {}
variable "rh_subscription_pool_id" {}

variable "openshift_inventory" {
  default = ""
}

variable "compute_node_count" {
  default = 1
}

variable "infra_node_count" {
  default = 1
}

variable "master_count" {
  default = 1
}

variable "master_spot_price" {
  default = "0.05"
}

variable "master_instance_type" {
  default = "m4.large"
}

variable "infra_instance_type" {
  default = "m4.large"
}

variable "compute_instance_type" {
  default = "m4.large"
}
