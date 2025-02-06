resource "local_file" "storageclass_deployment" {
  content = templatefile("${path.module}/manifest/storageclass.template.yaml", {
      fs_type     = var.fs_type
      vpus_per_gb = var.vpus_per_gb
  })
  filename = "${path.module}/storageclass.yaml"
}

resource "local_file" "pvc_deployment" {
  content = templatefile("${path.module}/manifest/pvc.template.yaml", {
      pvc_from_existing_block_volume = var.pvc_from_existing_block_volume
      block_volume_name              = var.pvc_from_existing_block_volume ? oci_core_volume.FoggyKitchenBlockVolume[0].display_name : var.block_volume_name
      block_volume_id                = var.pvc_from_existing_block_volume ? oci_core_volume.FoggyKitchenBlockVolume[0].id : ""
      block_volume_size              = var.pvc_from_existing_block_volume ? oci_core_volume.FoggyKitchenBlockVolume[0].size_in_gbs : var.block_volume_size
  })
  filename = "${path.module}/pvc.yaml"
}

resource "local_file" "nginx_deployment" {
  content = templatefile("${path.module}/manifest/nginx.template.yaml", {
      block_volume_name = var.pvc_from_existing_block_volume ? oci_core_volume.FoggyKitchenBlockVolume[0].display_name : var.block_volume_name
      is_arm_node_shape = local.is_arm_node_shape
  })
  filename = "${path.module}/nginx.yaml"
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

resource "null_resource" "deploy_oke_pvc" {
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool,
  local_file.storageclass_deployment,
  local_file.pvc_deployment,
  local_file.nginx_deployment,
  local_file.service_deployment]

  provisioner "local-exec" {
    command = "oci ce cluster create-kubeconfig --region ${var.region} --cluster-id ${module.fk-oke.cluster.id}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.storageclass_deployment.filename}  --request-timeout=60s"
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.pvc_deployment.filename}  --request-timeout=60s"
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "local-exec" {
    command = "kubectl get pvc"
  }

}

resource "null_resource" "deploy_oke_nginx" {
  depends_on = [
  module.fk-oke.cluster,
  module.fk-oke.node_pool,
  local_file.pvc_deployment,
  local_file.nginx_deployment,
  null_resource.deploy_oke_pvc]

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.nginx_deployment.filename}  --request-timeout=60s"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.service_deployment.filename}  --request-timeout=60s"
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

  provisioner "local-exec" {
    command = "kubectl describe pod nginx"
  }

  provisioner "local-exec" {
    command = "kubectl get services"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete service lb-service"
  }

}


