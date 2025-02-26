resource "oci_identity_dynamic_group" "fk_oke_dynamic_group" {
  provider       = oci.homeregion
  compartment_id = var.tenancy_ocid
  name           = "fk_oke_instance_principal_dg"
  description    = "Dynamic Group dla worker nodes OKE do provisioning Autonomous Database"
  matching_rule = "ALL {instance.compartment.id='${var.compartment_ocid}'}"
}

resource "oci_identity_policy" "fk_oke_adbs_identity_principal" { 
  provider       = oci.homeregion
  name           = "fk_oke_adbs_identity_principal"
  description    = "Policy to enable fk_oke_instance_principal_dg to manage Autonomous Database and read OCI Vaults"
  compartment_id = var.tenancy_ocid
  statements     = [
    "Allow dynamic-group fk_oke_instance_principal_dg to manage autonomous-database in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group fk_oke_instance_principal_dg to manage autonomous-backup in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group fk_oke_instance_principal_dg to read vaults in compartment id ${var.compartment_ocid}"
  ]
}
