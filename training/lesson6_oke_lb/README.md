# FoggyKitchen OCI Container Engine for Kubernetes with Terraform 

## LESSON 6 - Creating OKE Cluster with OCI LoadBalancer as Kubernetes Service

In this lesson, we delve into the process of creating an OKE (Oracle Kubernetes Engine) Cluster with OCI (Oracle Cloud Infrastructure) Load Balancer as a Kubernetes Service, offering a detailed guide to integrating robust load balancing capabilities within your Kubernetes deployments. This lesson focuses on the strategic implementation of OCI Load Balancer as an integral service within your OKE cluster, aiming to enhance the distribution of traffic across your applications for improved availability and performance. 

![](terraform-oci-fk-oke-lesson6.png)

## Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/mlinxfeld/terraform-oci-fk-oke/releases/latest/download/terraform-oci-fk-oke-lesson6.zip)

    If you aren't already signed in, when prompted, enter the tenancy and user credentials.

2. Review and accept the terms and conditions.

3. Select the region where you want to deploy the stack.

4. Follow the on-screen prompts and instructions to create the stack.

5. After creating the stack, click **Terraform Actions**, and select **Plan**.

6. Wait for the job to be completed, and review the plan.

    To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.

7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 

## Deploy Using the Terraform CLI in Cloud Shell

### Clone of the repo into OCI Cloud Shell

Now, you'll want a local copy of this repo. You can make that with the commands:
Clone the repo from github by executing the command as follows and then go to proper subdirectory:

```
martin_lin@codeeditor:~ (eu-frankfurt-1)$ git clone https://github.com/mlinxfeld/terraform-oci-fk-oke.git

martin_lin@codeeditor:~ (eu-frankfurt-1)$ cd terraform-oci-fk-oke

martin_lin@codeeditor:terraform-oci-fk-oke (eu-frankfurt-1)$ cd training/lesson6_oke_lb/
```

### Prerequisites
Create environment file with terraform.tfvars file starting with example file:

```
martin_lin@codeeditor:lesson6_oke_lb (eu-frankfurt-1)$ cp terraform.tfvars.example terraform.tfvars

martin_lin@codeeditor:lesson6_oke_lb (eu-frankfurt-1)$ vi terraform.tfvars

tenancy_ocid       = "ocid1.tenancy.oc1..<your_tenancy_ocid>"
compartment_ocid   = "ocid1.compartment.oc1..<your_comparment_ocid>"
region             = "<oci_region>"
```

### Initialize Terraform

Run the following command to initialize Terraform environment:

```
martin_lin@codeeditor:lesson6_oke_lb (eu-frankfurt-1)$ terraform init

Initializing the backend...
Initializing modules...
Downloading git::https://github.com/mlinxfeld/terraform-oci-fk-oke.git for fk-oke...
- fk-oke in .terraform/modules/fk-oke

Initializing provider plugins...
- Reusing previous version of oracle/oci from the dependency lock file
- Reusing previous version of hashicorp/tls from the dependency lock file
- Installing oracle/oci v5.29.0...
- Installed oracle/oci v5.29.0 (signed by a HashiCorp partner, key ID 1533A49284137CEB)
- Installing hashicorp/tls v4.0.5...
- Installed hashicorp/tls v4.0.5 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### Apply the changes 

Run the following command for applying changes with the proposed plan:

```
martin_lin@codeeditor:lesson6_oke_lb (eu-frankfurt-1)$ terraform apply
data.template_file.nginx_deployment: Reading...
data.template_file.nginx_deployment: Read complete after 0s [id=e8338d25ad6bc03b264552a9cc6b9020e244555c6f3c6edc2b30afa6347c1c44]
module.fk-oke.data.oci_containerengine_node_pool_option.fk_oke_node_pool_option: Reading...
module.fk-oke.data.oci_containerengine_cluster_option.fk_oke_cluster_option: Reading...
module.fk-oke.data.oci_containerengine_addon_options.fk_oke_addon_options: Reading...
module.fk-oke.data.oci_identity_availability_domains.AD: Reading...
module.fk-oke.data.oci_identity_availability_domains.ADs: Reading...
module.fk-oke.data.oci_identity_availability_domains.ADs: Read complete after 0s [id=IdentityAvailabilityDomainsDataSource-3596290162]
module.fk-oke.data.oci_identity_availability_domains.AD: Read complete after 0s [id=IdentityAvailabilityDomainsDataSource-3596290162]
module.fk-oke.data.oci_containerengine_cluster_option.fk_oke_cluster_option: Read complete after 0s [id=ContainerengineClusterOptionDataSource-1870923232]
data.oci_core_services.FoggyKitchenAllOCIServices: Reading...
module.fk-oke.data.oci_containerengine_addon_options.fk_oke_addon_options: Read complete after 0s [id=ContainerengineAddonOptionsDataSource-1219351960]
data.oci_core_services.FoggyKitchenAllOCIServices: Read complete after 0s [id=CoreServicesDataSource-0]
module.fk-oke.data.oci_containerengine_node_pool_option.fk_oke_node_pool_option: Read complete after 1s [id=ContainerengineNodePoolOptionDataSource-1870923232]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # data.template_file.service_deployment will be read during apply
  # (config refers to values not yet known)
 <= data "template_file" "service_deployment" {
      + id       = (known after apply)
      + rendered = (known after apply)
      + template = <<-EOT
            apiVersion: v1
            kind: Service
            metadata:
              name: lb-service
              labels:
                app: nginx
              annotations:
                oci.oraclecloud.com/load-balancer-type: "lb"
                service.beta.kubernetes.io/oci-load-balancer-shape: "${lb_shape}"
                ${ lb_shape == "flexible" ? "service.beta.kubernetes.io/oci-load-balancer-shape-flex-min: \"${flex_lb_min_shape}\"" : "" }
                ${ lb_shape == "flexible" ? "service.beta.kubernetes.io/oci-load-balancer-shape-flex-max: \"${flex_lb_max_shape}\"" : "" }  
                ${ lb_nsg ? "oci.oraclecloud.com/oci-network-security-groups: \"${lb_nsg_id}\"" : "" }
            spec:
              type: LoadBalancer
              ${ use_reserved_public_ip_for_lb == "true" ? "loadBalancerIP: \"${reserved_public_ip_for_lb}\"" : "" }
              ports:
              - port: ${lb_listener_port}
              selector:
                app: nginx
        EOT
      + vars     = {
          + "flex_lb_max_shape"             = "100"
          + "flex_lb_min_shape"             = "10"
          + "lb_listener_port"              = "80"
          + "lb_nsg"                        = "true"
          + "lb_nsg_id"                     = (known after apply)
          + "lb_shape"                      = "flexible"
          + "reserved_public_ip_for_lb"     = (known after apply)
          + "use_reserved_public_ip_for_lb" = "true"
        }
    }

(...)

  # module.fk-oke.tls_private_key.public_private_key_pair will be created
  + resource "tls_private_key" "public_private_key_pair" {
      + algorithm                     = "RSA"
      + ecdsa_curve                   = "P224"
      + id                            = (known after apply)
      + private_key_openssh           = (sensitive value)
      + private_key_pem               = (sensitive value)
      + private_key_pem_pkcs8         = (sensitive value)
      + public_key_fingerprint_md5    = (known after apply)
      + public_key_fingerprint_sha256 = (known after apply)
      + public_key_openssh            = (known after apply)
      + public_key_pem                = (known after apply)
      + rsa_bits                      = 2048
    }

Plan: 24 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + Cluster    = {
      + id                 = (known after apply)
      + kubernetes_version = "v1.28.2"
      + name               = "FoggyKitchenOKECluster"
    }
  + KubeConfig = (known after apply)
  + NodePool   = {
      + id                 = [
          + (known after apply),
        ]
      + kubernetes_version = [
          + "v1.28.2",
        ]
      + name               = [
          + "FoggyKitchenNodePool1",
        ]
      + nodes              = [
          + (known after apply),
        ]
    }

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

(...)

null_resource.deploy_nginx: Still creating... [2m0s elapsed]
null_resource.deploy_nginx: Provisioning with 'local-exec'...
null_resource.deploy_nginx (local-exec): Executing: ["/bin/sh" "-c" "kubectl get pods"]
null_resource.deploy_nginx (local-exec): NAME                                READY   STATUS              RESTARTS   AGE
null_resource.deploy_nginx (local-exec): nginx-deployment-6d999996df-5qrbc   1/1     Running             0          2m2s
null_resource.deploy_nginx (local-exec): nginx-deployment-6d999996df-62k6m   1/1     Running             0          2m2s
null_resource.deploy_nginx (local-exec): nginx-deployment-6d999996df-b5mtz   0/1     ContainerCreating   0          2m2s
null_resource.deploy_nginx (local-exec): nginx-deployment-6d999996df-cfrwx   1/1     Running             0          2m2s
null_resource.deploy_nginx (local-exec): nginx-deployment-6d999996df-gdkcm   1/1     Running             0          2m2s
null_resource.deploy_nginx (local-exec): nginx-deployment-6d999996df-gh7ms   1/1     Running             0          2m2s
null_resource.deploy_nginx (local-exec): nginx-deployment-6d999996df-r4l2h   1/1     Running             0          2m2s
null_resource.deploy_nginx (local-exec): nginx-deployment-6d999996df-rm8c9   1/1     Running             0          2m2s
null_resource.deploy_nginx (local-exec): nginx-deployment-6d999996df-snw5r   1/1     Running             0          2m2s
null_resource.deploy_nginx (local-exec): nginx-deployment-6d999996df-zzk5k   0/1     ContainerCreating   0          2m2s
null_resource.deploy_nginx: Provisioning with 'local-exec'...
null_resource.deploy_nginx (local-exec): Executing: ["/bin/sh" "-c" "kubectl get services"]
null_resource.deploy_nginx (local-exec): NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)             AGE
null_resource.deploy_nginx (local-exec): kubernetes   ClusterIP      10.96.0.1       <none>          443/TCP,12250/TCP   9m9s
null_resource.deploy_nginx (local-exec): lb-service   LoadBalancer   10.96.126.216   138.3.241.120   80:31974/TCP        2m2s
null_resource.deploy_nginx: Creation complete after 2m6s [id=7319859307512728147]

Apply complete! Resources: 24 added, 0 changed, 0 destroyed.

Outputs:

Cluster = {
  "id" = "ocid1.cluster.oc1.eu-frankfurt-1.aaaaaaaaxlevqty5n5vdvayxrh5viyqv6cwegq4wazdjwt4f3c2epp26bmkq"
  "kubernetes_version" = "v1.28.2"
  "name" = "FoggyKitchenOKECluster"
}
KubeConfig = <<EOT
---
apiVersion: v1
kind: ""
clusters:
- name: cluster-c2epp26bmkq
  cluster:
    server: https://130.162.216.38:6443
    certificate-authority-data: LS0tLS(...)S0tLS0tCg==
users:
- name: user-c2epp26bmkq
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: oci
      args:
      - ce
      - cluster
      - generate-token
      - --cluster-id
      - ocid1.cluster.oc1.eu-frankfurt-1.aaaaaaaaxlevqty5n5vdvayxrh5viyqv6cwegq4wazdjwt4f3c2epp26bmkq
      - --region
      - eu-frankfurt-1
      env: []
contexts:
- name: context-c2epp26bmkq
  context:
    cluster: cluster-c2epp26bmkq
    user: user-c2epp26bmkq
current-context: context-c2epp26bmkq

EOT
NodePool = {
  "id" = tolist([
    "ocid1.nodepool.oc1.eu-frankfurt-1.aaaaaaaamy6bpkfmtvicrfyyhyl5e5sibgfkirzc46chuqf7lnc4h22nqt5q",
  ])
  "kubernetes_version" = tolist([
    "v1.28.2",
  ])
  "name" = tolist([
    "FoggyKitchenNodePool1",
  ])
  "nodes" = [
    tolist([
      "10.20.30.181",
      "10.20.30.90",
      "10.20.30.95",
    ]),
  ]
}

```

### Destroy the changes 

Run the following command for destroying all resources:

```
martin_lin@codeeditor:lesson6_oke_lb (eu-frankfurt-1)$ terraform destroy

data.template_file.nginx_deployment: Reading...
data.template_file.nginx_deployment: Read complete after 0s [id=e8338d25ad6bc03b264552a9cc6b9020e244555c6f3c6edc2b30afa6347c1c44]
local_file.nginx_deployment: Refreshing state... [id=daacc54085c4f86be24e42313b713188fe250a4f]
module.fk-oke.tls_private_key.public_private_key_pair: Refreshing state... [id=a0d8d08f600145b9e1a27e09c39510dd245f7319]
module.fk-oke.data.oci_identity_availability_domains.AD: Reading...
module.fk-oke.data.oci_identity_availability_domains.ADs: Reading...
module.fk-oke.data.oci_containerengine_addon_options.fk_oke_addon_options: Reading...
module.fk-oke.data.oci_containerengine_node_pool_option.fk_oke_node_pool_option: Reading...
module.fk-oke.data.oci_containerengine_cluster_option.fk_oke_cluster_option: Reading...
oci_core_public_ip.FoggyKitchenReservedPublicIP[0]: Refreshing state... [id=ocid1.publicip.oc1.eu-frankfurt-1.amaaaaaadngk4giaftzhc5jadrkapkjwozhaqbdzkxn6nysc55pl5knxzsrq]
data.oci_core_services.FoggyKitchenAllOCIServices: Reading...


(...)

Plan: 0 to add, 0 to change, 24 to destroy.

(...)

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

null_resource.deploy_nginx: Destroying... [id=7319859307512728147]
null_resource.deploy_nginx: Provisioning with 'local-exec'...
null_resource.deploy_nginx (local-exec): Executing: ["/bin/sh" "-c" "kubectl delete service lb-service"]
null_resource.deploy_nginx (local-exec): service "lb-service" deleted
oci_core_network_security_group_security_rule.FoggyKitchenOKELBSecurityEgressGroupRule[0]: Destroying... [id=3DEBCD]
oci_core_network_security_group_security_rule.FoggyKitchenOKELBSecurityIngressGroupRules[0]: Destroying... [id=4D52EA]
oci_core_network_security_group_security_rule.FoggyKitchenNSGRule12250: Destroying... [id=A1600C]
oci_core_network_security_group_security_rule.FoggyKitchenNSGRule6443: Destroying... [id=EA3C09]
oci_core_network_security_group_security_rule.FoggyKitchenNSGRule12250: Destruction complete after 0s
oci_core_network_security_group_security_rule.FoggyKitchenOKELBSecurityEgressGroupRule[0]: Destruction complete after 0s
oci_core_network_security_group_security_rule.FoggyKitchenOKELBSecurityIngressGroupRules[0]: Destruction complete after 0s
oci_core_network_security_group_security_rule.FoggyKitchenNSGRule6443: Destruction complete after 0s
(...)
module.fk-oke.oci_containerengine_cluster.fk_oke_cluster: Still destroying... [id=ocid1.cluster.oc1.eu-frankfurt-1.aaaaaa...yxrh5viyqv6cwegq4wazdjwt4f3c2epp26bmkq, 4m20s elapsed]
module.fk-oke.oci_containerengine_cluster.fk_oke_cluster: Still destroying... [id=ocid1.cluster.oc1.eu-frankfurt-1.aaaaaa...yxrh5viyqv6cwegq4wazdjwt4f3c2epp26bmkq, 4m30s elapsed]
module.fk-oke.oci_containerengine_cluster.fk_oke_cluster: Destruction complete after 4m35s
oci_core_subnet.FoggyKitchenOKEAPIEndpointSubnet: Destroying... [id=ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaauoxgutzv5m4zmn23tqb4ggow4xua4crjqlklk3pnyqwbvuixilra]
oci_core_subnet.FoggyKitchenOKELBSubnet: Destroying... [id=ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaazatuxvqvjbmx3jr6tkxr2dydiqs4b7ehkhz6an62rsugugfz65pa]
oci_core_subnet.FoggyKitchenOKEAPIEndpointSubnet: Destruction complete after 1s
oci_core_security_list.FoggyKitchenOKEAPIEndpointSecurityList: Destroying... [id=ocid1.securitylist.oc1.eu-frankfurt-1.aaaaaaaautymvturfeoqd2lfcdavxrajl2khcxtvxv53qz6tm6i76c3bf4ua]
oci_core_security_list.FoggyKitchenOKEAPIEndpointSecurityList: Destruction complete after 0s
oci_core_subnet.FoggyKitchenOKELBSubnet: Destruction complete after 2s
oci_core_route_table.FoggyKitchenVCNPublicRouteTable: Destroying... [id=ocid1.routetable.oc1.eu-frankfurt-1.aaaaaaaaxkvd6ar2riuxg4apkyjkvbvd3lfj5vlt4yqr6hbrrdoirr7363xq]
oci_core_route_table.FoggyKitchenVCNPublicRouteTable: Destruction complete after 0s
oci_core_internet_gateway.FoggyKitchenInternetGateway: Destroying... [id=ocid1.internetgateway.oc1.eu-frankfurt-1.aaaaaaaabvyoqc3kptfyketftuteoskjgfdglzr6kl4536gsgdc7c662hypq]
oci_core_internet_gateway.FoggyKitchenInternetGateway: Destruction complete after 0s
oci_core_virtual_network.FoggyKitchenVCN: Destroying... [id=ocid1.vcn.oc1.eu-frankfurt-1.amaaaaaadngk4gia4ye7lcaskhngychcpajkn63ggi3zd7fzmaly37wf2sba]
oci_core_virtual_network.FoggyKitchenVCN: Destruction complete after 1s

Destroy complete! Resources: 24 destroyed.

```