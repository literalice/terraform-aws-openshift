variable "platform_name" {
  description = "The name of the cluster that is used for tagging some resources"
}

variable "key_pair_public_key_path" {
  description = "AWS key pair that is used for instances of the cluster includes the bastion"
}

variable "key_pair_private_key_path" {
  description = "AWS key pair that is used for instances of the cluster includes the bastion"
}

variable "operator_cidrs" {
  type = "list"
  default = ["0.0.0.0/0"]
  description = "CIDRS that is allowed from which master api can be accessed"
}

variable "public_access_cidrs" {
  type = "list"
  default = ["0.0.0.0/0"]
  description = "CIDRS that is allowed from which public users can access served services in the cluster"
}

variable "infra_node_count" {
  default = 2
}

variable "master_count" {
  default = 1
}

variable "upstream" {
  description = "Sets true if you want to install Origin."
  default = false
}

variable "rh_subscription_pool_id" {
  description = "Red Hat subscription pool id for OpenShift Container Platform"
  default = ""
}

variable "rhn_username" {
  description = "Red Hat Network login username for registration system of the OpenShift Container Platform cluster"
  default = ""
}

variable "rhn_password" {
  description = "Red Hat Network login password for registration system of the OpenShift Container Platform cluster"
  default = ""
}

variable "openshift_major_version" {
  default = "3.7"
}

variable "openshift_image_tag" {
  default = "v3.7"
}

# Domains

variable "platform_default_subdomain" {
  description = "Public DNS subdomain for access to services served in the cluster"
}
