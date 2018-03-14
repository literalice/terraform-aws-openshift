variable "platform_name" {
}

variable "key_pair_private_key_path" {
  default = ""
}

variable "operator_cidrs" {
  type = "list"
  default = ["0.0.0.0/0"]
}

variable "public_access_cidrs" {
  type = "list"
  default = ["0.0.0.0/0"]
}

variable "infra_node_count" {
  default = 2
}

variable "master_count" {
  default = 1
}

variable "rh_subscription_pool_id" {
}

variable "rhn_username" {
}

variable "rhn_password" {
}

variable "platform_default_subdomain" {
}
