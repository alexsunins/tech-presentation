variable "project_id" {
  type        = string
  description = "GCP project ID"
}


variable "zone" {
  type        = string
  description = "Zone for the VM"
}


variable "vm_name" {
  type        = string
  description = "The name of the GCE instance"
}


variable "additional_disk" {
  description = <<EOF

    Configuration values for the additional disk.

    name => the name of the disk
    size => the size of the disk
  EOF

  type = object({
    name = string
    size = number
  })

  default = null
}


variable "machine_type" {
  type        = string
  description = "Type of the GCE instance"
}


variable "machine_image" {
  type = object({
    family  = string
    project = string
  })

  description = <<EOF
    The image for the instance.

    family = the image family, e.g. debian-11
    project = a project where the image is stored, e.g. debian-cloud
  EOF
}


variable "boot_disk_size" {
  type        = number
  description = "The size of the boot disk"
  default     = 10
}


variable "labels" {
  type        = map(string)
  description = "Labels to attach to the resource"
  default     = null
}


variable "network" {
  type        = string
  description = "The name of the network where to launch the instance"
}


variable "subnetwork" {
  type        = string
  description = "The name of the subnetwork where to launch the instance"
}


variable "service_account_email" {
  type        = string
  description = "Email address of a service account for the instance"
  default     = null
}


variable "service_account_iam_roles" {
  description = "IAM roles to map to the service account of the instance"
  type        = list(string)
  default     = []
}


variable "metadata_startup_script" {
  type        = string
  description = "Script to runs when the instance boots up"
  default     = null
}


# added in v2.0.0
variable "external_static_ip_address" {
  type = object({
    reserve_and_attach = bool
  })

  default = {
    reserve_and_attach = false
  }

  description = <<EOF
    If true, will reserve and attach an external static IP address to the instance.
  EOF
}

# added in v3.0.0
variable "firewall_rules_to_allow" {
  default = null

  type = list(object({
    rule_name    = string
    protocol     = string
    port         = number
    source_range = string
    network_tags = list(string)
  }))

  description = <<EOF
    List of firewall rules to allow ingress to the instance.

    rule_name    = the name of the rule. It is a unique identifier that is required so that we can iterate over the list.
    protocol     = protocol to allow the traffic on
    port         = port to allow the traffic on
    source_range = IP address in CIDR range to allow ingress from.
    network_tags = List of network tags that will be applied to both the instance and the rules.
  EOF
}

# added in v4.0.0
variable "tags" {
  default     = null
  type        = list(string)
  description = "Tags to add to the instance"
}


variable "service_account_scopes" {
  type        = list(string)
  description = "Google API scopes to assign to the service account of the instance"
  default = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}


variable "enable_secure_boot" {
  type        = bool
  default     = false
  description = <<EOT
    Verify the digital signature of all boot components,
    and halt the boot process if signature verification fails.
    
    Defaults to false
  EOT
}
