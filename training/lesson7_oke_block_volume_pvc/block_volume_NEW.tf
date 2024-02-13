resource "oci_core_volume" "FoggyKitchenBlockVolume" {
  count               = var.pvc_from_existing_block_volume ? 1 : 0
  provider            = oci.targetregion
  availability_domain = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0].name : var.availablity_domain_name
  compartment_id      = var.compartment_ocid 
  display_name        = var.block_volume_name
  size_in_gbs         = var.block_volume_size
  vpus_per_gb         = var.vpus_per_gb 
}
