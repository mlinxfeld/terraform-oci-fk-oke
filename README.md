# terraform-oci-fk-oke

These is Terraform module that deploys [Container Engine for Kubernetes (OKE)](https://docs.oracle.com/en-us/iaas/Content/ContEng/home.htm) on [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com/en_US/cloud-infrastructure).

## About
Oracle Cloud Infrastructure Container Engine for Kubernetes is a fully-managed, scalable, and highly available service that you can use to deploy your containerized applications to the cloud. Use Container Engine for Kubernetes (sometimes abbreviated to just OKE) when your development team wants to reliably build, deploy, and manage cloud-native applications. 

## Prerequisites
1. Download and install Terraform (v1.0 or later)
2. Download and install the OCI Terraform Provider (v4.4.0 or later)
3. Export OCI credentials. (this refer to the https://github.com/oracle/terraform-provider-oci )


## What's a Module?
A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such as a database or server cluster. Each Module is created using Terraform, and includes automated tests, examples, and documentation. It is maintained both by the open source community and companies that provide commercial support.
Instead of figuring out the details of how to run a piece of infrastructure from scratch, you can reuse existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself, you can leverage the work of the Module community to pick up infrastructure improvements through a version number bump.

## How to use this Module
Each Module has the following folder structure:
* [root](): This folder contains a root module.
* [training](): This folder contains self-study training how to use the module:
  - [Lesson 1: Creating OKE Basic Cluster](training/lesson1_oke_basic_cluster): In this lesson, we'll guide you through the process of setting up a Basic OKE Cluster. This type of cluster supports all essential features offered by Kubernetes and the Container Engine for Kubernetes, but it lacks the advanced functionalities available in enhanced clusters, like virtual nodes and cluster add-on management. Although basic clusters are equipped with a service level objective (SLO), they do not come with a financially-backed service level agreement (SLA). 
  - [Lesson 2: Creating OKE Enhanced Cluster](training/lesson2_oke_enhanced_cluster): In this tutorial, we will walk you through the configuration of an Enhanced OKE (Oracle Kubernetes Engine) Cluster. This advanced cluster configuration extends beyond the core capabilities offered by Kubernetes and the Container Engine for Kubernetes, incorporating premium features such as virtual nodes, cluster add-on management, and autoscaling. Unlike basic clusters, enhanced clusters are designed with a service level objective (SLO) and are supported by a financially-backed service level agreement (SLA), ensuring higher reliability and performance for your mission-critical applications. Enhanced clusters are ideal for users requiring advanced management, scalability, and reliability features directly integrated into their Kubernetes environment.
  - [Lesson 3: Creating OKE Enhanced Cluster with OKE Add-Ons](training/lesson3_oke_addons): In this lesson, we delve into the creation of an OKE Enhanced Cluster with OKE Add-Ons, providing a comprehensive tutorial on how to leverage the advanced features of Oracle Kubernetes Engine (OKE). This lesson focuses on the enhanced cluster setup, emphasizing the integration of OKE Add-Ons for a robust, scalable, and efficient Kubernetes environment. 
  - [Lesson 4: Creating OKE Enhanced Cluster with Virtual NodePool](training/lesson4_oke_virtual_nodes): In this lesson, we focus on setting up an OKE Enhanced Cluster with a Virtual NodePool. Virtual NodePools is a feature that enables on-demand scalability and efficient resource management without the need for physical node management. 
  - [Lesson 5: Creating OKE Enhanced Cluster with Autoscaler OKE Add-on](training/lesson5_oke_autoscaler): In this lesson we explore the creation of an OKE Enhanced Cluster with the Autoscaler as an OKE Add-on, providing a step-by-step tutorial to harness the power of automatic scaling within your Oracle Kubernetes Engine (OKE) deployments. 
  - [Lesson 6: Creating OKE Cluster with OCI LoadBalancer as Kubernetes Servicee](training/lesson6_oke_lb): In this lesson, we delve into the process of creating an OKE (Oracle Kubernetes Engine) Cluster with OCI (Oracle Cloud Infrastructure) Load Balancer as a Kubernetes Service, offering a detailed guide to integrating robust load balancing capabilities within your Kubernetes deployments. This lesson focuses on the strategic implementation of OCI Load Balancer as an integral service within your OKE cluster, aiming to enhance the distribution of traffic across your applications for improved availability and performance.
  - [Lesson 7: Creating OKE Cluster with OCI Block Volume as Kubernetes PVC](training/lesson7_oke_block_volume_pvc): In this lesson, we guide you through the creation of an OKE (Oracle Kubernetes Engine) Cluster with OCI (Oracle Cloud Infrastructure) Block Volume as Kubernetes Persistent Volume Claims (PVCs), providing a comprehensive tutorial on enhancing your Kubernetes deployments with durable and scalable storage solutions. This lesson is specifically designed to teach you how to leverage OCI Block Volumes for persistent storage needs within your Kubernetes environment, ensuring data persistence across pod reassignments and restarts. We will cover the intricacies of integrating OCI Block Volumes as PVCs, including provisioning, attaching, and managing block storage volumes to meet the dynamic storage requirements of your applications.
  - [Lesson 8: Creating OKE Cluster with OCI File Storage Service as Kubernetes PVC](training/lesson8_oke_fss_pvc): In this lesson, we take a comprehensive look at creating an OKE (Oracle Kubernetes Engine) Cluster with OCI (Oracle Cloud Infrastructure) File Storage Service as Kubernetes Persistent Volume Claims (PVCs). This tutorial is aimed at equipping you with the knowledge to incorporate OCI File Storage Service into your Kubernetes deployments, offering a scalable, shared storage solution that supports the concurrent access needs of your applications. Throughout this lesson, we will dive into the process of setting up and integrating OCI File Storage Service as PVCs, demonstrating how to provision and mount shared file systems within your Kubernetes environment. The focus will be on the seamless management of file storage, enabling applications to efficiently share data across multiple pods and nodes.
  - [Lesson 9: Creating OKE Cluster with image taken from OCI Registry](training/lesson9_oke_ocir): In this lesson, we focus on the creation of an OKE (Oracle Kubernetes Engine) Cluster utilizing images stored in the OCI Registry (OCIR). This tutorial aims to provide a detailed walkthrough for leveraging the Oracle Cloud Infrastructure Registry, a managed Docker registry service, for storing and managing your Docker images. Throughout this lesson, we will guide you through the process of configuring your OKE cluster to pull application images directly from OCIR, highlighting the seamless integration between OCI services and Kubernetes deployments.

To deploy OKE using this Module with minimal effort use this:

```hcl
module "fk-oke" {
  source                        = "github.com/mlinxfeld/terraform-oci-fk-oke"
  tenancy_ocid                  = var.tenancy_ocid      # Our tenancy OCID     
  compartment_ocid              = var.compartment_ocid  # Compartment OCID where OKE and network will be deployed
  cluster_type                  = "basic"               # Basic cluster
  use_existing_vcn              = false                 # Module itself will create all necessary network resources
  is_api_endpoint_subnet_public = true                  # OKE API Endpoint will be public (Internet facing)
  is_lb_subnet_public           = true                  # OKE LoadBalanacer will be public (Internet facing)
  is_nodepool_subnet_public     = true                  # OKE NodePool will be public (Internet facing)
}

```

Argument | Description
--- | ---
compartment_ocid | Compartment's OCID where OKE will be created
ssh_authorized_keys | Public SSH key to be included in the ~/.ssh/authorized_keys file for the default user on the instance
ssh_private_key | The private key to access instance
use_existing_vcn | If you want to inject already exisitng VCN then you need to set the value to TRUE.
use_existing_nsg | If you want to inject already exisitng NSG then you need to set the value to TRUE.
vcn_cidr | If use_existing_vcn is set to FALSE then you can define VCN CIDR block and then it will used to create VCN within the module.
vcn_id | If use_existing_vcn is set to TRUE then you can pass VCN OCID and module will use it to create OKE Cluster.
node_subnet_id | If use_existing_vcn is set to TRUE then you can pass NodePool Subnet OCID and module will use it to create OKE NodePool.
nodepool_subnet_cidr | If use_existing_vcn is set to FALSE then you can define NodePool CIDR block and then it will used to create NodePool within the module.
lb_subnet_id | If use_existing_vcn is set to TRUE then you can pass LoadBalancer Subnet OCID and module will use it to define service_lb_subnet_ids.
lb_subnet_cidr | If use_existing_vcn is set to FALSE then you can define LoadBalancer CIDR block and then it will used to create service_lb_subnet_ids within the module.
api_endpoint_subnet_id | If use_existing_vcn is set to TRUE then you can pass API EndPoint Subnet OCID and module will use it to define endpoint_config.
api_endpoint_subnet_cidr | If use_existing_vcn is set to FALSE then you can define API EndPoint CIDR block and then it will used to create endpoint_config within the module.
api_endpoint_nsg_ids | If use_existing_vcn is set to TRUE then you can pass API EndPoint Network Security Groups OCID and module will use it to define endpoint_config.
oci_vcn_ip_native | If you want to enable POD native networking (PODs associated with VCN/Subnet), then you need to turn the value to TRUE.
pod_subnet_id | If use_existing_vcn is set to TRUE and oci_vcn_ip_native is set to TRUE then you can pass POD Subnet OCID and module will associate it with each and every POD in OKE.
max_pods_per_node | If oci_vcn_ip_native is set to TRUE then you can define maximum value of PODs per OKE node.
oke_cluster_name | The name of the OKE Cluster.
vcn_native | if you want to use modern VCN-native mode for OKE then you need to set the value to TRUE.
is_api_endpoint_subnet_public | If vcn_native is set to TRUE then you can choose if API EndPoint will be in the public or private subnet.
is_lb_subnet_public | If vcn_native is set to TRUE then you can choose if LoadBalancer will be in the public or private subnet.
is_nodepool_subnet_public | If vcn_native is set to TRUE then you can choose if NodePool will be in the public or private subnet.
k8s_version | Version of K8S.
pool_name | Node Pool Name.
node_shape | Shape for the Node Pool members. 
node_ocpus | If node_shape is Flex then you can define OCPUS.
node_memory | If node_shape is Flex then you can define Memory.
node_linux_version | Node Oracle Linux Version.
node_count | Number of Nodes in the Pool.
pods_cidr | K8S PODs CIDR
services_cidr | K8S Services CIDR
cluster_options_add_ons_is_kubernetes_dashboard_enabled | If you want to set cluster_options_add_ons_is_kubernetes_dashboard_enabled to TRUE.
cluster_options_add_ons_is_tiller_enabled | If you want to use Tiller then you need to set the value to TRUE.
cluster_type | Default is **enhanced** may also be set to **basic**
node_pool_initial_node_labels_key | You can pass here node_pool_initial_node_labels_key.
node_pool_initial_node_labels_value | You can pass here node_pool_initial_node_labels_value.
node_eviction_node_pool_settings | If you want to setup Node Eviction Details configuration then set the value to TRUE (by default the value is equal to FALSE).
eviction_grace_duration | If node_eviction_node_pool_settings is set to TRUE then you can setup duration after which OKE will give up eviction of the pods on the node. PT0M will indicate you want to delete the node without cordon and drain. Default PT60M, Min PT0M, Max: PT60M. Format ISO 8601 e.g PT30M
is_force_delete_after_grace_duration | If node_eviction_node_pool_settings is set to TRUE then you can setup underlying compute instance to be deleted event if you cannot evict all the pods in grace period.
ssh_public_key | If you want to use your own SSH public key instead of generated onne by the module.


## Contributing
This project is open source. Please submit your contributions by forking this repository and submitting a pull request! FoggyKitchen appreciates any contributions that are made by the open source community.

## License
Copyright (c) 2024 FoggyKitchen.com

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.
