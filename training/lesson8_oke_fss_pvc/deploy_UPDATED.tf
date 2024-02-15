resource "local_file" "pv_deployment" {
  content  = data.template_file.pv_deployment.rendered
  filename = "${path.module}/pv.yaml"
}

resource "local_file" "pvc_deployment" {
  content  = data.template_file.pvc_deployment.rendered
  filename = "${path.module}/pvc.yaml"
}

resource "local_file" "nginx_deployment" {
  count    = var.number_of_pods
  content  = data.template_file.nginx_deployment[count.index].rendered
  filename = "${path.module}/nginx${count.index+1}.yaml"
}

resource "local_file" "service_deployment" {
  content  = data.template_file.service_deployment.rendered
  filename = "${path.module}/service.yaml"
}

resource "null_resource" "deploy_oke_pv" {
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool,
  local_file.pv_deployment]

  provisioner "local-exec" {
    command = "oci ce cluster create-kubeconfig --region ${var.region} --cluster-id ${module.fk-oke.cluster.id}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.pv_deployment.filename} --request-timeout=60s"
  }

  provisioner "local-exec" {
    command = "sleep 10"
  }

}

resource "null_resource" "deploy_oke_pvc" {
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool,
  null_resource.deploy_oke_pv,
  local_file.pvc_deployment]

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.pvc_deployment.filename} --request-timeout=60s"
  }

  provisioner "local-exec" {
    command = "sleep 10"
  }

}

resource "null_resource" "deploy_oke_label_nodes" {
  count = var.node_pool_size
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool,
  local_file.nginx_deployment,
  null_resource.deploy_oke_pvc]

  provisioner "local-exec" {
    command = "kubectl label node ${element(module.fk-oke.node_pool.nodes[0], count.index)} nodeName=node${count.index+1} --request-timeout=60s"
  }  

}

resource "null_resource" "deploy_oke_nginx" {
  count = var.number_of_pods
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool,
  local_file.nginx_deployment,
  null_resource.deploy_oke_label_nodes]

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.nginx_deployment[count.index].filename} --request-timeout=60s"
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

}

resource "null_resource" "deploy_oke_service" {
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool,
  local_file.nginx_deployment,
  null_resource.deploy_oke_label_nodes,
  null_resource.deploy_oke_nginx]

  provisioner "local-exec" {
    command = "kubectl get pods"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.service_deployment.filename} --request-timeout=60s"
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }

  provisioner "local-exec" {
    command = "kubectl get services"
  }
  
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete service lb-service"
  }
}
