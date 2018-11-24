variable "platform_name" {}

variable "rh_subscription_pool_id" {
  description = "Red Hat subscription pool id for OpenShift Container Platform"
  default     = ""
}

variable "rhn_username" {
  description = "Red Hat Network login username for registration system of the OpenShift Container Platform cluster"
  default     = ""
}

variable "rhn_password" {
  description = "Red Hat Network login password for registration system of the OpenShift Container Platform cluster"
  default     = ""
}

variable "bastion_ssh_user" {}

variable "bastion_endpoint" {}

variable "platform_private_key" {}

variable "openshift_major_version" {
  default = "3.11"
}

variable "use_community" {
  default = false
}

variable "master_domain" {}

variable "platform_domain" {}
