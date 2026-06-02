variable "host_type" {
  type        = string
  description = "Type of host to deploy - either bastion-host or kubectl-proxy"
}


variable "machine_type" {
  type        = string
  description = "Machine type for the proxy of GKE cluster"
  default     = "e2-micro"
}


variable "project" {
  type        = string
  description = "The name of GCP project"
}


variable "region" {
  type        = string
  description = "Region of GKE cluster"
}


variable "cluster_name" {
  type        = string
  description = "The name of GKE cluster"
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


variable "network" {
  type        = string
  description = "VPC where to deploy the instance"
  default     = "default"
}


variable "subnetwork" {
  type        = string
  description = "Subnet where to deploy the instance"
}


variable "ssh_allow" {
  type        = list(string)
  description = "Users that are allowed to connect to the host over SSH"
  default     = []
}

