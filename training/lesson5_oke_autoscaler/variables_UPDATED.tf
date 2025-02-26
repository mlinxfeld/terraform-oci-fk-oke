variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}

variable "enable_autoscaler_addon" {
  default = false
}

variable "autoscaler_authtype_workload" {
  default = false
}

variable "kubernetes_version" {
  default = "v1.31.1"
}

variable "node_linux_version" {
  default = "8.10"
}

variable "node_pool_size" {
  default = 3
}

variable "min_number_of_nodes" {
  default = 3
}

variable "max_number_of_nodes" {
  default = 5
}

