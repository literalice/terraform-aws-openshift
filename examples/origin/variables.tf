variable "platform_name" {
}

variable "key_pair_private_key_path" {
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
  default = 1
}

variable "master_count" {
  default = 1
}

variable "master_spot_price" {
  default = ""
}

variable "platform_default_subdomain" {
}
