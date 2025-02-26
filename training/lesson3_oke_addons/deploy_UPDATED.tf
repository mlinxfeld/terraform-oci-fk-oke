resource "local_file" "adbs_deployment" {
  content  = templatefile("${path.module}/manifest/adbs.template.yaml", {
    compartment_ocid           = var.compartment_ocid
    adbs_database_display_name = var.adbs_database_display_name
    adbs_database_dbname       = var.adbs_database_dbname
  })
  filename = "${path.module}/adbs.yaml"
}

resource "null_resource" "verify_oracle-database-operator-system" {
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool, 
  module.fk-oke.oke_cluster_addons]

  provisioner "local-exec" {
    command = "oci ce cluster create-kubeconfig --region ${var.region} --cluster-id ${module.fk-oke.cluster.id}"
  }

  provisioner "local-exec" {
    command = "sleep 600"
  }

  provisioner "local-exec" {
    command = "kubectl get pods -n oracle-database-operator-system"
  }

  provisioner "local-exec" {
    command = "kubectl logs -n oracle-database-operator-system -l control-plane=controller-manager --tail=50" 
  }

}

resource "null_resource" "create_adbs_secret" {
  count = var.deploy_adbs ? 1 : 0
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool, 
  module.fk-oke.oke_cluster_addons,
  null_resource.verify_oracle-database-operator-system]

  provisioner "local-exec" {
    command = "kubectl create secret generic adbs-admin-password --from-literal=adbs-admin-password='${var.adbs_admin_password}' --namespace default"
  }

  provisioner "local-exec" {
    command = "kubectl get secret -n default"
  }

  provisioner "local-exec" {
    command = "kubectl get secret adbs-admin-password -n default -o yaml"
  }

}

resource "null_resource" "deploy_adbs" {
  count = var.deploy_adbs ? 1 : 0
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool, 
  module.fk-oke.oke_cluster_addons,
  null_resource.verify_oracle-database-operator-system,
  null_resource.create_adbs_secret,
  local_file.adbs_deployment]

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.adbs_deployment.filename}"
  }

  provisioner "local-exec" {
    command = "sleep 240"
  }

  provisioner "local-exec" {
    command = "kubectl get autonomousdatabase -n default"
  }

  provisioner "local-exec" {
    command = "kubectl describe autonomousdatabase fk-adbs-instance -n default"
  }  

  #provisioner "local-exec" {
  #  when    = destroy
  #  command = "kubectl delete autonomousdatabase fk-adbs-instance -n default"
  #}
}
