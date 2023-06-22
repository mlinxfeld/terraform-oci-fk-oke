variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}

variable "number_of_nginx_replicas" {
   default = 10
}

variable "pool_name" {
   default = "FoggyKitchenVirtualNodePool"
}

variable "virtual_nodepool_pod_shape" {
  default = "Pod.Standard.E4.Flex"
}
