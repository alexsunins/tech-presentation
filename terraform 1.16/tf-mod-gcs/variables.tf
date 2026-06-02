variable "project_id" {
  description = "GCS Project ID."
  type        = string
}


variable "bucket_location" {
  description = "GCS Bucket Location."
  type        = string
  default     = "EU"
}


variable "bucket_name" {
  description = "Bucket name. Please note that a random 8 character suffix will be added to the value of this variable"
  type        = string
}


variable "enable_uniform_bucket_level_access" {
  type        = bool
  default     = true
  description = <<EOT
    When uniform bucket-level access enabled on a bucket, Access Control Lists (ACLs) are disabled,
    and only bucket-level Identity and Access Management (IAM) permissions grant access to that bucket and the objects it contains. 
  EOT
}


variable "force_destroy" {
  description = "Delete all objects when deleting bucket."
  type        = bool
  default     = false
}


variable "storage_class" {
  description = <<EOT
    The Storage class of the GCS bucket.
    Supported Values - STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE.
  EOT

  type    = string
  default = "STANDARD"

  validation {
    condition     = can(regex("(STANDARD|MULTI_REGIONAL|REGIONAL|NEARLINE|COLDLINE|ARCHIVE)$", var.storage_class))
    error_message = "Invalid GCS Storage Class Name. Supported Values - STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  }
}


variable "enable_versioning" {
  description = "Enable GCS Bucket versioning."
  type        = bool
  default     = false
}


variable "lifecycle_rules" {
  description = <<EOT
    List of GCS bucket lifecycle rule - https://cloud.google.com/storage/docs/lifecycle#configuration."
    Provider documentation - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket#lifecycle_rule
    Supported actions within this module - type and storage_class. 
    Supported condition within this module - age, with_state and created_before.
  EOT

  type = set(object({
    action    = map(string)
    condition = map(string)
  }))

  default = []
}


variable "retention_policy" {
  description = <<EOF
    Map of Retention policy values. Provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket#retention_policy
  EOF
  type        = map(any)
  default     = null
}


variable "logging" {
  description = "Logging Bucket details. Provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#logging"
  type        = map(any)
  default     = null
}


variable "storage_admins" {
  description = "List of IAM members to grant roles/storage.admin permission"
  type        = list(any)
  default     = []
}


variable "object_admins" {
  description = "List of IAM members to grant roles/storage.objectAdmin permission"
  type        = list(any)
  default     = []
}


variable "object_creators" {
  description = "List of IAM members to grant roles/storage.objectCreator permission"
  type        = list(any)
  default     = []
}


variable "object_viewers" {
  description = "List of IAM members to grant roles/storage.objectViewer permission"
  type        = list(any)
  default     = []
}


variable "labels" {
  description = "Labels to assign on the GCS bucket."
  type        = map(any)
}


variable "cors" {
  type = object({
    origin          = list(string)
    method          = list(string)
    response_header = list(string)
    max_age_seconds = number
  })

  description = "The bucket's Cross-Origin Resource Sharing (CORS) configuration"

  default = null
}
