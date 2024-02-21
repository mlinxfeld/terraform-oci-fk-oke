
output "KubeConfig" {
  value = module.fk-oke.KubeConfig
}

output "Cluster" {
  value = module.fk-oke.cluster
}

output "NodePool" {
  value = module.fk-oke.node_pool
}
