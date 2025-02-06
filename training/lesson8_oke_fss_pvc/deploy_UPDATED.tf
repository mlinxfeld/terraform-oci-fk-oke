resource "local_file" "pv_deployment" {
  content = templatefile("${path.module}/manifest/pv.template.yaml", {
      file_storage_export_path = var.file_storage_export_path
      mount_target_ip_address  = var.mount_target_ip_address
      file_system_id           = oci_file_storage_file_system.FoggyKitchenFilesystem.id
      pv_name                  = var.pv_name
      pv_size                  = var.pv_size
  })
  filename = "${path.module}/pv.yaml"
}

resource "local_file" "pvc_deployment" {
  content = templatefile("${path.module}/manifest/pvc.template.yaml", {
      pvc_name = var.pvc_name
      pvc_size = var.pvc_size
      pv_name  = var.pv_name
  })
  filename = "${path.module}/pvc.yaml"
}

resource "local_file" "nginx_deployment" {
  count   = var.number_of_pods
  content = templatefile("${path.module}/manifest/nginx.template.yaml", {
      pvc_name                = var.pvc_name
      pod_name                = "${var.pod_name}"
      number_of_pods_replicas = var.number_of_pods_replicas
      node_index              = "${(count.index % 3) + 1}"
      is_arm_node_shape       = local.is_arm_node_shape
  })
  filename = "${path.module}/nginx${count.index+1}.yaml"
}


resource "local_file" "service_deployment" {
  content = templatefile("${path.module}/manifest/service.template.yaml", {
      lb_shape          = var.lb_shape
      flex_lb_min_shape = var.flex_lb_min_shape 
      flex_lb_max_shape = var.flex_lb_max_shape  
      lb_listener_port  = var.lb_listener_port
      lb_nsg            = var.lb_nsg
      lb_nsg_id         = var.lb_nsg ? oci_core_network_security_group.FoggyKitchenOKELBSecurityGroup[0].id : ""
      use_reserved_public_ip_for_lb = var.use_reserved_public_ip_for_lb
      reserved_public_ip_for_lb     = var.use_reserved_public_ip_for_lb ? oci_core_public_ip.FoggyKitchenReservedPublicIP[0].ip_address : ""
  })
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
