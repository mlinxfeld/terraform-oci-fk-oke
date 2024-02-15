resource "oci_file_storage_mount_target" "FoggyKitchenMountTarget" {
  provider            = oci.targetregion
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  subnet_id           = oci_core_subnet.FoggyKitchenOKENodesPodsSubnet.id
  ip_address          = var.mount_target_ip_address
  display_name        = "FoggyKitchenMountTarget"
}

resource "oci_file_storage_export_set" "FoggyKitchenExportset" {
  provider        = oci.targetregion
  mount_target_id = oci_file_storage_mount_target.FoggyKitchenMountTarget.id
  display_name    = "FoggyKitchenExportset"
}

resource "oci_file_storage_file_system" "FoggyKitchenFilesystem" {
  provider            = oci.targetregion
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "FoggyKitchenFilesystem"
}

resource "oci_file_storage_export" "FoggyKitchenExport" {
  provider       = oci.targetregion
  export_set_id  = oci_file_storage_mount_target.FoggyKitchenMountTarget.export_set_id
  file_system_id = oci_file_storage_file_system.FoggyKitchenFilesystem.id
  path           = var.file_storage_export_path
}
