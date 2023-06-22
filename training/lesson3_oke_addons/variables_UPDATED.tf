variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}

variable "number_of_nginx_replicas" {
   default = 10
}

variable "fk_oke_addon_map" {
  type = map(object({
    configurations = map(object({
      config_value = string
    }))
    addon_version = string
  }))
  default = {
    "CertManager" = {
      configurations = {
        "numOfReplicas" = {
          config_value = "1"
        }
      }
      addon_version = "v1.11.0"
    },
    "OracleDatabaseOperator" = {
      configurations = {
        "numOfReplicas" = {
          config_value = "1"
        }
      }
      addon_version = "0.2.0-fips-2"
    }
  }
}
