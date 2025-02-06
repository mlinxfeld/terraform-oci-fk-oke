# FoggyKitchen OCI Container Engine for Kubernetes with Terraform 

## LESSON 5 - Creating OKE Enhanced Cluster with Autoscaler OKE Add-on

In this lesson we explore the creation of an OKE Enhanced Cluster with the Autoscaler as an OKE Add-on, providing a step-by-step tutorial to harness the power of automatic scaling within your Oracle Kubernetes Engine (OKE) deployments. 

![](terraform-oci-fk-oke-lesson5.png)

## Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/mlinxfeld/terraform-oci-fk-oke/releases/latest/download/terraform-oci-fk-oke-lesson5.zip)

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

martin_lin@codeeditor:terraform-oci-fk-oke (eu-frankfurt-1)$ cd training/lesson5_oke_autoscaler/
```

### Prerequisites
Create environment file with terraform.tfvars file starting with example file:

```
martin_lin@codeeditor:lesson5_oke_autoscaler (eu-frankfurt-1)$ cp terraform.tfvars.example terraform.tfvars

martin_lin@codeeditor:lesson5_oke_autoscaler (eu-frankfurt-1)$ vi terraform.tfvars

tenancy_ocid       = "ocid1.tenancy.oc1..<your_tenancy_ocid>"
compartment_ocid   = "ocid1.compartment.oc1..<your_comparment_ocid>"
region             = "<oci_region>"
```

### Initialize Terraform

Run the following command to initialize Terraform environment:

```
martin_lin@codeeditor:lesson5_oke_autoscaler (eu-frankfurt-1)$ terraform init

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
martin_lin@codeeditor:lesson5_oke_autoscaler (eu-frankfurt-1)$ terraform apply

data.oci_identity_region_subscriptions.home_region_subscriptions: Reading...
data.oci_identity_region_subscriptions.home_region_subscriptions: Read complete after 0s [id=IdentityRegionSubscriptionsDataSource-3596290162]
module.fk-oke.data.oci_containerengine_cluster_option.fk_oke_cluster_option: Reading...
module.fk-oke.data.oci_containerengine_node_pool_option.fk_oke_node_pool_option: Reading...
module.fk-oke.data.oci_containerengine_addon_options.fk_oke_addon_options: Reading...
module.fk-oke.data.oci_identity_availability_domains.ADs: Reading...
module.fk-oke.data.oci_identity_availability_domains.AD: Reading...
module.fk-oke.data.oci_core_services.AllOCIServices[0]: Reading...
module.fk-oke.data.oci_identity_availability_domains.ADs: Read complete after 0s [id=IdentityAvailabilityDomainsDataSource-3596290162]
module.fk-oke.data.oci_identity_availability_domains.AD: Read complete after 0s [id=IdentityAvailabilityDomainsDataSource-3596290162]
module.fk-oke.data.oci_core_services.AllOCIServices[0]: Read complete after 0s [id=CoreServicesDataSource-0]
module.fk-oke.data.oci_containerengine_cluster_option.fk_oke_cluster_option: Read complete after 0s [id=ContainerengineClusterOptionDataSource-1870923232]
module.fk-oke.data.oci_containerengine_addon_options.fk_oke_addon_options: Read complete after 0s [id=ContainerengineAddonOptionsDataSource-1219351960]
module.fk-oke.data.oci_containerengine_node_pool_option.fk_oke_node_pool_option: Read complete after 1s [id=ContainerengineNodePoolOptionDataSource-1870923232]

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # oci_identity_policy.fk_oke_autoscaler_policy will be created
  + resource "oci_identity_policy" "fk_oke_autoscaler_policy" {
      + ETag           = (known after apply)
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaasbktycknc4n4ja673cmnldkrj2s3gdbz7d2heqzzxn7pe64ksbia"
      + defined_tags   = (known after apply)
      + description    = "Policy to enable OKE Cluster Autoscaler (Workload Principal)"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + inactive_state = (known after apply)
      + lastUpdateETag = (known after apply)
      + name           = "fk_oke_autoscaler_policy"
      + policyHash     = (known after apply)
      + state          = (known after apply)
      + statements     = (known after apply)
      + time_created   = (known after apply)
      + version_date   = (known after apply)
    }

  # module.fk-oke.data.oci_containerengine_addons.fk_oke_cluster_addons will be read during apply
  # (config refers to values not yet known)
 <= data "oci_containerengine_addons" "fk_oke_cluster_addons" {
      + addons     = (known after apply)
      + cluster_id = (known after apply)
      + id         = (known after apply)
    }
(...)

Plan: 17 to add, 0 to change, 0 to destroy.

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

module.fk-oke.oci_containerengine_addon.fk_oke_autoscaler_addon[0]: Still creating... [10s elapsed]
module.fk-oke.oci_containerengine_addon.fk_oke_autoscaler_addon[0]: Creation complete after 15s [id=clusters/ocid1.cluster.oc1.eu-frankfurt-1.aaaaaaaa7opsktcg4ooflorjpmwxsixh3biidnsl45mtqcohdchdsdzv5z3a/addons/ClusterAutoscaler]

Apply complete! Resources: 17 added, 0 changed, 0 destroyed.

Outputs:

Cluster = {
  "id" = "ocid1.cluster.oc1.eu-frankfurt-1.aaaaaaaa7opsktcg4ooflorjpmwxsixh3biidnsl45mtqcohdchdsdzv5z3a"
  "kubernetes_version" = "v1.28.2"
  "name" = "FoggyKitchenOKECluster"
}
KubeConfig = <<EOT
---
apiVersion: v1
kind: ""
clusters:
- name: cluster-chdsdzv5z3a
  cluster:
    server: https://141.144.224.35:6443
    certificate-authority-data: LS0tLS1CR(...)0tLS0tCg==
users:
- name: user-chdsdzv5z3a
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: oci
      args:
      - ce
      - cluster
      - generate-token
      - --cluster-id
      - ocid1.cluster.oc1.eu-frankfurt-1.aaaaaaaa7opsktcg4ooflorjpmwxsixh3biidnsl45mtqcohdchdsdzv5z3a
      - --region
      - eu-frankfurt-1
      env: []
contexts:
- name: context-chdsdzv5z3a
  context:
    cluster: cluster-chdsdzv5z3a
    user: user-chdsdzv5z3a
current-context: context-chdsdzv5z3a

EOT
NodePool = {
  "id" = tolist([
    "ocid1.nodepool.oc1.eu-frankfurt-1.aaaaaaaau552kszkwqrkd2sxh7k7ropy4bjmpui553j33o427nfxulgbnq2q",
  ])
  "kubernetes_version" = tolist([
    "v1.28.2",
  ])
  "name" = tolist([
    "FoggyKitchenNodePool1",
  ])
  "nodes" = [
    tolist([
      "10.0.1.86",
      "10.0.1.65",
      "10.0.1.94",
    ]),
  ]
}
```

### Destroy the changes 

Run the following command for destroying all resources:

```
martin_lin@codeeditor:lesson5_oke_autoscaler (eu-frankfurt-1)$ terraform destroy

data.template_file.nginx_deployment: Reading...
data.template_file.nginx_deployment: Read complete after 1s [id=e8338d25ad6bc03b264552a9cc6b9020e244555c6f3c6edc2b30afa6347c1c44]
local_file.nginx_deployment: Refreshing state... [id=daacc54085c4f86be24e42313b713188fe250a4f]
data.oci_identity_region_subscriptions.home_region_subscriptions: Reading...
data.oci_identity_region_subscriptions.home_region_subscriptions: Read complete after 0s [id=IdentityRegionSubscriptionsDataSource-3596290162]
oci_identity_policy.fk_oke_virtual_node_pool_policy: Refreshing state... [id=ocid1.policy.oc1..aaaaaaaab5oodvxi52zzfdlpy5yb56fxkami64hcqwcbqdvsx6aim63keiga]
module.fk-oke.tls_private_key.public_private_key_pair: Refreshing state... [id=085a4821dad51c1f153ad0b166d528eb1d94d51d]
module.fk-oke.data.oci_containerengine_addon_options.fk_oke_addon_options: Reading...
module.fk-oke.data.oci_containerengine_node_pool_option.fk_oke_node_pool_option: Reading...
module.fk-oke.data.oci_identity_availability_domains.AD: Reading...
module.fk-oke.data.oci_core_services.AllOCIServices[0]: Reading...
module.fk-oke.data.oci_containerengine_cluster_option.fk_oke_cluster_option: Reading...
module.fk-oke.oci_core_vcn.fk_oke_vcn[0]: Refreshing state... [id=ocid1.vcn.oc1.eu-frankfurt-1.amaaaaaadngk4giahjbeqi2bhvvsngjsyyarrxxmxw5tkxerzhytn2osk5nq]
module.fk-oke.data.oci_identity_availability_domains.ADs: Reading...
module.fk-oke.data.oci_identity_availability_domains.ADs: Read complete after 0s [id=IdentityAvailabilityDomainsDataSource-3596290162]
module.fk-oke.data.oci_identity_availability_domains.AD: Read complete after 0s [id=IdentityAvailabilityDomainsDataSource-3596290162]
module.fk-oke.data.oci_containerengine_cluster_option.fk_oke_cluster_option: Read complete after 0s [id=ContainerengineClusterOptionDataSource-1870923232]
module.fk-oke.oci_core_nat_gateway.fk_oke_natgw[0]: Refreshing state... [id=ocid1.natgateway.oc1.eu-frankfurt-1.aaaaaaaa5hisg6dbp4kjtrrshdk7cvvvlwf3cyikjj7bx2jzl5f4qorctglq]
module.fk-oke.oci_core_internet_gateway.fk_oke_igw[0]: Refreshing state... [id=ocid1.internetgateway.oc1.eu-frankfurt-1.aaaaaaaaocz4jjky3vew6lne3kaej7ihclfb3yhw3btmveaslacizxqswzoa]
module.fk-oke.data.oci_containerengine_addon_options.fk_oke_addon_options: Read complete after 0s [id=ContainerengineAddonOptionsDataSource-1219351960]
module.fk-oke.oci_core_route_table.fk_oke_rt_via_igw[0]: Refreshing state... [id=ocid1.routetable.oc1.eu-frankfurt-1.aaaaaaaaezxeiwk5jdw4klacqpypuuhd35p6yewj65av3seudlyswva662pa]
module.fk-oke.data.oci_core_services.AllOCIServices[0]: Read complete after 0s [id=CoreServicesDataSource-0]
module.fk-oke.oci_core_security_list.fk_oke_api_endpoint_subnet_sec_list[0]: Refreshing state... [id=ocid1.securitylist.oc1.eu-frankfurt-1.aaaaaaaaypm5j6y3hyetd7icawlgxoodwe5xqzfqxtgah2o7jyptepsfsjmq]
module.fk-oke.oci_core_service_gateway.fk_oke_sg[0]: Refreshing state... [id=ocid1.servicegateway.oc1.eu-frankfurt-1.aaaaaaaac5v2fadfvxnjixykjpbgg7bgp2prqsxoaz3mxb2trtomv64f5kcq]
module.fk-oke.oci_core_security_list.fk_oke_nodepool_subnet_sec_list[0]: Refreshing state... [id=ocid1.securitylist.oc1.eu-frankfurt-1.aaaaaaaaumia73rv7ol5zddimu4hoqq2z6po6uxt4nrozbxjjnzuvzic4xkq]
module.fk-oke.oci_core_route_table.fk_oke_rt_via_natgw_and_sg[0]: Refreshing state... [id=ocid1.routetable.oc1.eu-frankfurt-1.aaaaaaaagcn6buw7tr76ip3mv6mnxmkqipoeuu4nz5bj2h6tls4f47ly7xjq]
module.fk-oke.data.oci_containerengine_node_pool_option.fk_oke_node_pool_option: Read complete after 0s [id=ContainerengineNodePoolOptionDataSource-1870923232]
module.fk-oke.oci_core_subnet.fk_oke_lb_subnet[0]: Refreshing state... [id=ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaalkxrbldh7abwuwt6tmgq6qnl6r44mpel3yucwi7kh5goyx6jbfna]
module.fk-oke.oci_core_subnet.fk_oke_nodepool_subnet[0]: Refreshing state... [id=ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaawkmqoam2n2c3d3pqlicefcjy7arssmupnrlxokplrbxjhfex3dbq]
module.fk-oke.oci_core_subnet.fk_oke_api_endpoint_subnet[0]: Refreshing state... [id=ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaacp2o6w7vzphklspa3zopqantrkonhnhzw45vbwjbxbdt2xgdvpia]
module.fk-oke.oci_containerengine_cluster.fk_oke_cluster: Refreshing state... [id=ocid1.cluster.oc1.eu-frankfurt-1.aaaaaaaa35m42wqloe2rlk272fxwge63gyijw42p4hokljnd6c6lkzii2jva]
module.fk-oke.data.oci_containerengine_addons.fk_oke_cluster_addons: Reading...
module.fk-oke.data.oci_containerengine_cluster_kube_config.KubeConfig: Reading...
module.fk-oke.oci_containerengine_virtual_node_pool.fk_oke_virtual_node_pool[0]: Refreshing state... [id=ocid1.virtualnodepool.oc1.eu-frankfurt-1.amaaaaaadngk4giaenjxetnuwsu4f4aqb34w47oxtssfsezffhye3qicfnwq]
module.fk-oke.data.oci_containerengine_addons.fk_oke_cluster_addons: Read complete after 0s [id=ContainerengineAddonsDataSource-1384344501]
null_resource.deploy_nginx: Refreshing state... [id=4216408386760643991]
module.fk-oke.data.oci_containerengine_cluster_kube_config.KubeConfig: Read complete after 0s [id=ContainerengineClusterKubeConfigDataSource-3939584060]

(...)

null_resource.deploy_nginx: Refreshing state... [id=6451609765774392253]
module.fk-oke.data.oci_containerengine_cluster_kube_config.KubeConfig: Read complete after 0s [id=ContainerengineClusterKubeConfigDataSource-1653731019]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # local_file.nginx_deployment will be destroyed
  - resource "local_file" "nginx_deployment" {
      - content              = <<-EOT
            apiVersion: apps/v1
            kind: Deployment

(...)

Plan: 0 to add, 0 to change, 17 to destroy.

(...)

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

oci_identity_policy.fk_oke_autoscaler_policy: Destroying... [id=ocid1.policy.oc1..aaaaaaaah7koygf3v73657fmrinkxi6przk66ut2sajurwjybsdehglnrmga]
oci_identity_policy.fk_oke_autoscaler_policy: Destruction complete after 1s
module.fk-oke.oci_containerengine_addon.fk_oke_autoscaler_addon[0]: Destroying... [id=clusters/ocid1.cluster.oc1.eu-frankfurt-1.aaaaaaaa7opsktcg4ooflorjpmwxsixh3biidnsl45mtqcohdchdsdzv5z3a/addons/ClusterAutoscaler]
module.fk-oke.oci_containerengine_addon.fk_oke_autoscaler_addon[0]: Still destroying... [id=clusters/ocid1.cluster.oc1.eu-frankfurt...hdchdsdzv5z3a/addons/ClusterAutoscaler, 10s elapsed]

(...)
module.fk-oke.oci_core_security_list.fk_oke_api_endpoint_subnet_sec_list[0]: Destruction complete after 0s
module.fk-oke.oci_core_route_table.fk_oke_rt_via_igw[0]: Destruction complete after 0s
module.fk-oke.oci_core_internet_gateway.fk_oke_igw[0]: Destroying... [id=ocid1.internetgateway.oc1.eu-frankfurt-1.aaaaaaaakcwu45bczlf6lru6mlpjctezf322q2tpzjbootwrj4tfgubywprq]
module.fk-oke.oci_core_route_table.fk_oke_rt_via_natgw_and_sg[0]: Destruction complete after 0s
module.fk-oke.oci_core_service_gateway.fk_oke_sg[0]: Destroying... [id=ocid1.servicegateway.oc1.eu-frankfurt-1.aaaaaaaakpvpsilqpbkpenmkmwfrhsxlssox2jpqy4sg5vig7fpcm5ouwj6a]
module.fk-oke.oci_core_nat_gateway.fk_oke_natgw[0]: Destroying... [id=ocid1.natgateway.oc1.eu-frankfurt-1.aaaaaaaay6obxb2vwmwdtuh64spfhss7nck7stwedcsbyj3wnmv5wnoasuoa]
module.fk-oke.oci_core_internet_gateway.fk_oke_igw[0]: Destruction complete after 1s
module.fk-oke.oci_core_nat_gateway.fk_oke_natgw[0]: Destruction complete after 1s
module.fk-oke.oci_core_service_gateway.fk_oke_sg[0]: Destruction complete after 7s
module.fk-oke.oci_core_vcn.fk_oke_vcn[0]: Destroying... [id=ocid1.vcn.oc1.eu-frankfurt-1.amaaaaaadngk4giaw24x6wtegot4r7rmuz32vnw5w7buur6zw4vmqgyvolsa]
module.fk-oke.oci_core_vcn.fk_oke_vcn[0]: Destruction complete after 1s

Destroy complete! Resources: 17 destroyed.
```


## Contributing
This project is open source. Please submit your contributions by forking this repository and submitting a pull request! [FoggyKitchen.com](https://foggykitchen.com/) appreciates any contributions that are made by the open source community.

## License
Copyright (c) 2025 [FoggyKitchen.com](https://foggykitchen.com/)

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.