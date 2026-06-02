variable "name" {
  description = "The name of the node pool"
}


variable "gke_cluster" {
  type = object({
    name                          = string
    location                      = string
    service_account_email_address = string
  })
  description = "GKE cluster info"
}


variable "node_count" {
  type        = number
  description = "The node count in the pool"
}


variable "image_type" {
  type        = string
  description = "Image type for the node pool"
}


variable "machine_type" {
  type        = string
  description = "Machine type for the node pool"
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


variable "labels" {
  description = "Labels to assign on the GCP resources."
  type        = map(any)
  default = {
    "provisioned-by" = "terraform"
  }
}