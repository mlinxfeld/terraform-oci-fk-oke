locals {
  availability_domains       = var.availability_domain == "" ? data.oci_identity_availability_domains.ADs.availability_domains : data.oci_identity_availability_domains.AD.availability_domains
  node_pool_image_ids        = data.oci_containerengine_node_pool_option.fk_oke_node_pool_option.sources
  oke_specific_image_id      = (var.node_pool_image_type == "oke" && length(regexall("GPU|A1", var.node_shape)) == 0) ? (element([for source in local.node_pool_image_ids : source.image_id if length(regexall("Oracle-Linux-${var.node_linux_version}-20[0-9]*.*-OKE-${local.k8s_version_only}", source.source_name)) > 0], 0)) : (var.node_pool_image_type == "oke" && length(regexall("GPU", var.node_shape)) > 0) ? (element([for source in local.node_pool_image_ids : source.image_id if length(regexall("Oracle-Linux-${var.node_linux_version}-Gen[0-9]-GPU-20[0-9]*.*-OKE-${local.k8s_version_only}", source.source_name)) > 0], 0)) : (var.node_pool_image_type == "oke" && length(regexall("A1", var.node_shape)) > 0) ? (element([for source in local.node_pool_image_ids : source.image_id if length(regexall("Oracle-Linux-${var.node_linux_version}-aarch64-20[0-9]*.*-OKE-${local.k8s_version_only}", source.source_name)) > 0], 0)) : null
  oci_platform_image_id      = (var.node_pool_image_type == "platform" && length(regexall("GPU|A1", var.node_shape)) == 0) ? (element([for source in local.node_pool_image_ids : source.image_id if length(regexall("^(Oracle-Linux-${var.node_linux_version}-\\d{4}.\\d{2}.\\d{2}-[0-9]*)$", source.source_name)) > 0], 0)) : (var.node_pool_image_type == "platform" && length(regexall("GPU", var.node_shape)) > 0) ? (element([for source in local.node_pool_image_ids : source.image_id if length(regexall("^(Oracle-Linux-${var.node_linux_version}-Gen[0-9]-GPU-\\d{4}.\\d{2}.\\d{2}-[0-9]*)$", source.source_name)) > 0], 0)) : (var.node_pool_image_type == "platform" && length(regexall("A1", var.node_shape)) > 0) ? (element([for source in local.node_pool_image_ids : source.image_id if length(regexall("^(Oracle-Linux-${var.node_linux_version}-aarch64-\\d{4}.\\d{2}.\\d{2}-[0-9]*)$", source.source_name)) > 0], 0)) : null
  k8s_version_length         = length(var.k8s_version)
  k8s_version_only           = substr(var.k8s_version,1,local.k8s_version_length)
  fk_oke_addon_map           = var.cluster_type == "enhanced" ? var.fk_oke_addon_map : {}
  
  # List with supported autoscaler images: https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengusingclusterautoscaler.htm
  autoscaler_image = {
    "v1.22.5" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.22.2-4",
    "v1.23.4" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.23.0-4",
    "v1.22.5" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.22.2-4",
    "v1.23.4" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.23.0-4",
    "v1.24.1" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.24.0-5",
    "v1.25.4" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.25.0-6",
    "v1.26.2" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.26.2-7"
  }
}
