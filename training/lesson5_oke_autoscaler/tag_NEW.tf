resource "oci_identity_tag_namespace" "fk_oke_cluster_tag_namespace" {
    provider       = oci.homeregion
    compartment_id = var.compartment_ocid
    description    = "Tag namespace for OKE worker nodes"
    name           = "oke-${random_id.tag.hex}"

    provisioner "local-exec" {
      command = "sleep 10"
    }
}

resource "oci_identity_tag" "fk_oke_cluster_tag" {
    provider         = oci.homeregion
    tag_namespace_id = oci_identity_tag_namespace.fk_oke_cluster_tag_namespace.id
    description      = "Tag to identify worker nodes in the OKE cluster"
    name             = "autoscaler"

    provisioner "local-exec" {
      command = "sleep 120"
    }
}
