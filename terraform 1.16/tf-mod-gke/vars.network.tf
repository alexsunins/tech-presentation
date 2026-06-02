# Variables related to the network config

variable "network_name" {
  description = "The name of VPC for GKE to run in."
  type        = string
  default     = "default"
}


variable "subnet" {
  description = <<EOD
    GCP subnetwork name.

    name        = the name of subnetwork where to place the cluster in.
    autocreate  = if set to true will create a subnet with the provided name.
      when creating a subnet Google docs suggest to follow the following naming convention:
        {company-name}-{description(App or BU)-label}-{region/zone-label}

    config      = if var.subnet.autocreate is set to true then the below parameters will be used when creating the subnet
      ip_cidr_range       = The range of internal addresses that are owned by this subnetwork.
      secondary_ip_range  = a list of configurations for secondary IP ranges for VM instances contained in this subnetwork.
        range_name    = The name associated with this subnetwork secondary range
        ip_cidr_range = The range of IP addresses belonging to this subnetwork secondary range
  EOD

  type = object({
    name       = string
    autocreate = bool

    config = object({
      ip_cidr_range = string
      secondary_ip_range = list(object({
        range_name    = string
        ip_cidr_range = string
      }))
    })
  })

  default = {
    name       = "default"
    autocreate = false
    config     = null
  }
}

