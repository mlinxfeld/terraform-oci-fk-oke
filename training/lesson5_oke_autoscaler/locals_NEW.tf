locals {

  # List with supported autoscaler images: https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengusingclusterautoscaler.htm
  autoscaler_image = {
    "v1.22.5" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.22.2-4",
    "v1.23.4" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.23.0-4",
    "v1.22.5" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.22.2-4",
    "v1.23.4" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.23.0-4",
    "v1.24.1" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.24.0-5",
    "v1.25.4" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.25.0-6",
    "v1.26.2" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.26.2-7"
  }

}
