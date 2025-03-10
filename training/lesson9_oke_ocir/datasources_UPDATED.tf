data "oci_core_services" "FoggyKitchenAllOCIServices" {
  provider       = oci.targetregion

  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

data "oci_identity_regions" "oci_regions" {
  filter {
    name   = "name"
    values = [var.region]
  }

}

data "oci_objectstorage_namespace" "test_namespace" {
  compartment_id = var.tenancy_ocid
}
