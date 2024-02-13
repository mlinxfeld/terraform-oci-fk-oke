resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
}

resource "oci_containerengine_cluster" "fk_oke_cluster" {
  compartment_id     = var.compartment_ocid
  kubernetes_version = var.k8s_version
  name               = var.oke_cluster_name
  vcn_id             = var.use_existing_vcn ? var.vcn_id : oci_core_vcn.fk_oke_vcn[0].id
  type               = lookup({"basic"="BASIC_CLUSTER","enhanced"="ENHANCED_CLUSTER"}, lower(var.cluster_type), "ENHANCED_CLUSTER")

  dynamic "endpoint_config" {
    for_each = var.vcn_native ? [1] : []
    content {
      is_public_ip_enabled = var.is_api_endpoint_subnet_public
      subnet_id            = var.use_existing_vcn ? var.api_endpoint_subnet_id : oci_core_subnet.fk_oke_api_endpoint_subnet[0].id
      nsg_ids              = var.use_existing_vcn ? var.api_endpoint_nsg_ids : []
    }
  }

  dynamic "cluster_pod_network_options" {
      for_each = var.oci_vcn_ip_native == true ? [1] : []
      content {
          cni_type = "OCI_VCN_IP_NATIVE"
      }
  }

  options {
    service_lb_subnet_ids = [var.use_existing_vcn ? var.lb_subnet_id : oci_core_subnet.fk_oke_lb_subnet[0].id]

    add_ons {
      is_kubernetes_dashboard_enabled = var.cluster_options_add_ons_is_kubernetes_dashboard_enabled
      is_tiller_enabled               = var.cluster_options_add_ons_is_tiller_enabled
    }

    admission_controller_options {
      is_pod_security_policy_enabled = var.cluster_options_admission_controller_options_is_pod_security_policy_enabled
    }

    dynamic "kubernetes_network_config" {
      for_each = var.oci_vcn_ip_native == true ? [] : [1]
        content {
            pods_cidr     = var.pods_cidr
            services_cidr = var.services_cidr
        }
    }
  }
}

