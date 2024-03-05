# Workload identity principal scenario (autoscaler_authtype_workload=true)
resource "oci_identity_policy" "fk_oke_autoscaler_policy_workload_identity_principal" {
  count          = var.autoscaler_authtype_workload ? 1 : 0  
  provider       = oci.homeregion
  name           = "fk_oke_autoscaler_policy_workload_identity_principal"
  description    = "Policy to enable OKE Cluster Autoscaler (Workload identity principal)"
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

# Instance principal scenario (autoscaler_authtype_workload=false)
resource "oci_identity_dynamic_group" "fk_oke_autoscaler_dg" {
  count          = var.autoscaler_authtype_workload ? 0 : 1  
  provider       = oci.homeregion
  compartment_id = var.tenancy_ocid
  name           = "fk_oke_autoscaler_dg"
  description    = "Dynamic group for OKE Cluster Autoscaler (Instance principal)"
  matching_rule  = "ALL {instance.compartment.id ='${var.compartment_ocid}'}"
}

resource "oci_identity_policy" "fk_oke_autoscaler_policy_instance_principal" {
  count          = var.autoscaler_authtype_workload ? 0 : 1  
  provider       = oci.homeregion
  name           = "fk_oke_autoscaler_policy_instance_principal"
  description    = "Policy to enable OKE Cluster Autoscaler (Instance principal)"
  compartment_id = var.tenancy_ocid
  statements     = [
    "Allow dynamic-group fk_oke_autoscaler_dg to manage cluster-node-pools in compartment id ${var.compartment_ocid}",   
    "Allow dynamic-group fk_oke_autoscaler_dg to manage instance-family in compartment id ${var.compartment_ocid}",  
    "Allow dynamic-group fk_oke_autoscaler_dg to use subnets in compartment id ${var.compartment_ocid}",  
    "Allow dynamic-group fk_oke_autoscaler_dg to read virtual-network-family in compartment id ${var.compartment_ocid}",  
    "Allow dynamic-group fk_oke_autoscaler_dg to use vnics in compartment id ${var.compartment_ocid}", 
    "Allow dynamic-group fk_oke_autoscaler_dg to inspect compartments in compartment id ${var.compartment_ocid}" 
  ]
}