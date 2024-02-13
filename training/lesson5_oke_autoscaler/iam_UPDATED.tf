resource "oci_identity_policy" "fk_oke_autoscaler_policy" {
  provider       = oci.homeregion
  name           = "fk_oke_autoscaler_policy"
  description    = "Policy to enable OKE Cluster Autoscaler (Workload Instance Principal)"
  compartment_id = var.tenancy_ocid
  statements     = [
    "Allow any-user to manage cluster-node-pools in compartment id ${var.compartment_ocid} where ALL {request.principal.type='workload', request.principal.namespace ='kube-system', request.principal.service_account = 'cluster-autoscaler', request.principal.cluster_id = '${module.fk-oke.cluster.id}'}",
    "Allow any-user to manage instance-family in compartment id ${var.compartment_ocid} where ALL {request.principal.type='workload', request.principal.namespace ='kube-system', request.principal.service_account = 'cluster-autoscaler', request.principal.cluster_id = '${module.fk-oke.cluster.id}'}",
    "Allow any-user to use subnets in compartment id ${var.compartment_ocid} where ALL {request.principal.type='workload', request.principal.namespace ='kube-system', request.principal.service_account = 'cluster-autoscaler', request.principal.cluster_id = '${module.fk-oke.cluster.id}'}",
    "Allow any-user to read virtual-network-family in compartment id ${var.compartment_ocid} where ALL {request.principal.type='workload', request.principal.namespace ='kube-system', request.principal.service_account = 'cluster-autoscaler', request.principal.cluster_id = '${module.fk-oke.cluster.id}'}",
    "Allow any-user to use vnics in compartment id ${var.compartment_ocid} where ALL {request.principal.type='workload', request.principal.namespace ='kube-system', request.principal.service_account = 'cluster-autoscaler', request.principal.cluster_id = '${module.fk-oke.cluster.id}'}",
    "Allow any-user to inspect compartments in compartment id ${var.compartment_ocid} where ALL {request.principal.type='workload', request.principal.namespace ='kube-system', request.principal.service_account = 'cluster-autoscaler', request.principal.cluster_id = '${module.fk-oke.cluster.id}'}"
  ]
}

