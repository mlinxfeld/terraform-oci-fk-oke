resource "random_id" "tag" {
  byte_length = 2
}

resource "oci_identity_dynamic_group" "fk_oke_dg" {
  provider       = oci.homeregion
  compartment_id = var.tenancy_ocid
  description    = "Dynamic Group for OKE Nodes/OKE Cluster"
  matching_rule  = "ALL {instance.compartment.id = '${var.compartment_ocid}', tag.oke-${random_id.tag.hex}.autoscaler.value = 'true'}"
  name           = "FoggyKitchenInstancePrincipalDynamicGroup-${random_id.tag.hex}"
}


resource "oci_identity_policy" "fk_oke_autoscaler_policy1" {
  provider       = oci.homeregion
  name           = "fk_oke_autoscaler_policy1-${random_id.tag.hex}"
  description    = "Policy to enable OKE Cluster Autoscaler (Instances)"
  compartment_id = var.tenancy_ocid
  statements     = [
    "Allow dynamic-group ${oci_identity_dynamic_group.fk_oke_dg.name} to manage cluster-node-pools in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.fk_oke_dg.name} to manage instance-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.fk_oke_dg.name} to use subnets in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.fk_oke_dg.name} to use vnics in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.fk_oke_dg.name} to inspect compartments in compartment id ${var.compartment_ocid}"
  ]
}

resource "oci_identity_policy" "fk_oke_autoscaler_policy2" {
  provider       = oci.homeregion
  name           = "fk_oke_autoscaler_policy2-${random_id.tag.hex}"
  description    = "Policy to enable OKE Cluster Autoscaler (Networking)"
  compartment_id = var.tenancy_ocid
  statements     = [
    "Allow dynamic-group ${oci_identity_dynamic_group.fk_oke_dg.name} to use subnets in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.fk_oke_dg.name} to read virtual-network-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.fk_oke_dg.name} to use vnics in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.fk_oke_dg.name} to inspect compartments in compartment id ${var.compartment_ocid}"
  ]
}

