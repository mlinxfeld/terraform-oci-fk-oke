
output "KubeConfig" {
  value = module.fk-oke.KubeConfig
}

output "Cluster" {
  value = module.fk-oke.cluster
}

output "NodePool" {
  value = module.fk-oke.node_pool
}

output "ClusterAddOns" {
  value = module.fk-oke.oke_cluster_addons
}

#output "AvailableClusterAddOns" {
#  value = module.fk-oke.oke_addon_options
#}
