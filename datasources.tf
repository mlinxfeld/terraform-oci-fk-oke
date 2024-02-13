data "oci_containerengine_cluster_option" "fk_oke_cluster_option" {
  cluster_option_id = "all"
}

data "oci_containerengine_node_pool_option" "fk_oke_node_pool_option" {
  node_pool_option_id = "all"
}

data "oci_core_services" "AllOCIServices" {
  count = var.use_existing_vcn ? 0 : 1
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

data "oci_identity_availability_domains" "AD" {
  compartment_id  = var.tenancy_ocid

  filter {
    name   = "name"
    values = ["${var.availability_domain}"]
  }
}


data "oci_containerengine_cluster_kube_config" "KubeConfig" {
  cluster_id    = oci_containerengine_cluster.fk_oke_cluster.id
  token_version = var.cluster_kube_config_token_version
}

data "oci_containerengine_addons" "fk_oke_cluster_addons" {
    cluster_id = oci_containerengine_cluster.fk_oke_cluster.id
}

data "oci_containerengine_addon_options" "fk_oke_addon_options" {
    kubernetes_version = var.k8s_version
}

