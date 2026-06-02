variable "cluster_name" {
  description = "GKE cluster name. If provided then this value will be included in the name of the router."
  type        = string
  default     = null
}


variable "region" {
  description = "GCP region for Cloud NAT"
  type        = string
}


variable "network_name" {
  description = "GCP Network for Cloud NAT"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "GCP subnet name for Cloud NAT"
  type        = string
}


variable "source_ip_ranges_to_nat" {
  description = <<EOD
        List of options for which source IPs in the subnetwork should have NAT enabled.
        Supported values include: ALL_IP_RANGES, LIST_OF_SECONDARY_IP_RANGES, PRIMARY_IP_RANGE.
    EOD

  type = list(string)
}


variable "secondary_ip_range_names" {
  description = <<EOD
        List of the secondary ranges of the subnetwork that are allowed to use NAT.
        This can be populated only if LIST_OF_SECONDARY_IP_RANGES is one of the values in source_ip_ranges_to_nat
    EOD

  type    = list(string)
  default = []
}

