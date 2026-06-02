# Basic variables related to the GKE cluster configuration

variable "gke_zone" {
  description = "Zone for GKE cluster."
  type        = string
}


variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
}


variable "release_channel" {
  type        = string
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `UNSPECIFIED`."
  default     = null
}


variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected location."
  default     = "latest"
}


variable "gke_sa_roles" {
  description = "List of roles to attach to GKE service account."
  type        = list(string)
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/storage.objectViewer"
  ]
}


variable "vpc_native" {
  type = object({
    enabled = bool
    ip_allocation = object({
      cluster_secondary_range_name  = string
      services_secondary_range_name = string
    })
  })

  default = {
    enabled       = true
    ip_allocation = null
  }

  description = <<EOD
    Whether to create VPC-Native or route-based cluster.

    enabled       = if set to true will create VPC-Native GKE cluster.
    ip_allocation = Required for VPC-Native clusters. Describes secondary ranges that are used for IP aliasing.
  EOD
}
