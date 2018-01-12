variable "platform_name" {}
variable "key_pair_public_key" {}
variable "key_pair_private_key_path" {}
variable "operator_cidrs" {
  type = "list"
  default = ["0.0.0.0/0"]
}
variable "public_access_cidrs" {
  type = "list"
  default = ["0.0.0.0/0"]
}

variable "rh_subscription_pool_id" {}
variable "rhn_username" {}
variable "rhn_password" {}

variable "platform_dns_name" {
  default = ""
}
variable "platform_private_dns_name" {
  default = ""
}
variable "master_public_dns_name" {
  default = ""
}
variable "master_dns_name" {
  default = ""
}

variable "infra_node_count" {
  default = 2
}
variable "master_count" {
  default = 3
}