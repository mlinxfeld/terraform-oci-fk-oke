variable "tenancy_ocid" {}
#variable "user_ocid" {}
#variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
#variable "fingerprint" {}

variable "availablity_domain_name" {
  default = ""
}

variable "oke_node_shape" {
  default = "VM.Standard.A1.Flex"
}

variable "oke_node_shape_memory" {
  default = 4
}

variable "oke_node_shape_ocpus" {
  default = 1
}

variable "lb_shape" {
  default = "flexible"
}

variable "flex_lb_min_shape" {
  default = 10
}

variable "flex_lb_max_shape" {
  default = 100
}

variable "use_reserved_public_ip_for_lb" {
  default = true
}

variable "lb_listener_port" {
  default = 80
}

variable "lb_nsg" {
  default = true
}

variable "network_cidrs" {
  type = map(string)

  default = {
    VCN-CIDR                        = "10.20.0.0/16"
    NODES-PODS-SUBNET-REGIONAL-CIDR = "10.20.30.0/24"
    LB-SUBNET-REGIONAL-CIDR         = "10.20.20.0/24"
    ENDPOINT-SUBNET-REGIONAL-CIDR   = "10.20.10.0/28"
    ALL-CIDR                        = "0.0.0.0/0"
  }
}

variable "node_pool_size" {
  default = 3
}

variable "number_of_pods" {
  default = 3
}

variable "number_of_pods_replicas" {
  default = 1
}

variable "pv_size" {
  default = 100
}

variable "pvc_size" {
  default = 100
}

variable "pv_name" {
  default = "oke-fsspv"
}

variable "pvc_name" {
  default = "oke-fsspvc"
}

variable "mount_target_ip_address" {
  default = "10.20.30.5"
}

variable "file_storage_export_path" {
  default = "/ocifss"
}

variable "pod_name" {
  default = "oke-fsspod"
}

