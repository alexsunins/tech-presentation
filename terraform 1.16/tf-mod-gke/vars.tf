variable "project_id" {
  description = "GCP Project ID."
  type        = string
}


variable "logging_service" {
  description = "Logging service name."
  type        = string
  default     = "logging.googleapis.com/kubernetes"
}


variable "monitoring_service" {
  description = "Monitoring service name."
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
}


variable "node_pool" {
  description = <<EOT
    GKE node pool configuration.

    name          -> the name of the pool
    node_count    -> how many nodes to deploy
    machine_type  -> node machine type
    image_type    -> node machine image
  EOT

  type = object({
    name         = string
    node_count   = number
    machine_type = string
    image_type   = string
  })

  default = {
    name         = "primary-node-pool"
    node_count   = 1
    image_type   = "COS_CONTAINERD"
    machine_type = "n2-standard-2"
  }
}


variable "enable_pod_security_policy_config" {
  description = "Whether to enable PSP/PSA"
  type        = bool
  default     = false
}


variable "disable_network_policy_config" {
  description = "Whether to disable network policies"
  type        = bool
  default     = true
}


variable "enable_vertical_pod_autoscaling" {
  description = "Whether to enable Vertical Pod Autoscaler"
  type        = bool
  default     = false
}


variable "labels" {
  description = "Labels to assign on the GCP resources."
  type        = map(any)
  default = {
    "provisioned-by" = "terraform"
  }
}


variable "cluster_name_alias_for_bastion_service_account" {
  default     = null
  type        = string
  description = <<EOT
    Service account name must match RegEx ^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$

    Therefore, the name of a service account has to be between 4 and 28 characters.

    The pattern for the name of a service account is:
      "gke-$${var.cluster_name}-kproxy-sa" or "gke-$${var.cluster_name}-bastion-sa"

    In order to avoid mismatching the regex this variable allows to use an alias
    for the name of GKE cluster
  EOT
}


variable "autoscaling" {
  description = <<EOT
    Configuration required by cluster autoscaler to adjust the size of the node pool to the current cluster usage

    nodes.min = Minimum number of nodes per zone in the NodePool. Must be >=0 and <= max_node_count
    nodes.max = Maximum number of nodes per zone in the NodePool. Must be >= min_node_count.
  EOT
  type = object({
    nodes = object({
      min = number
      max = number
    })
  })

  default = null
}


variable "protect_from_accidental_deletion" {
  description = "The variable to set deletion_protection"
  type        = bool
}
