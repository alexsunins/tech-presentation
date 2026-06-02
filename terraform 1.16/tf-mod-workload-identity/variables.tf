variable "project_id" {
  description = "GCS Project ID."
  type        = string
}


variable "application_name" {
  description = "Application name."
  type        = string
}


variable "insert_random_string" {
  description = <<EOD
    If this module used to create WI for the same application but across different GKE clusters then there will be a name conflict between
    GPC service accounts since the name for WI GCP service account is made up as "$${var.application_name}-gsa".

    To avoid the name conflict this variable can be set to true and then a random 6 character string will be injected in to the name:
      "$${var.application_name}-$${random_str}-gsa"
  EOD

  type    = bool
  default = false
}


variable "k8s_namespace" {
  description = "Namespace for the Kubernetes service account."
  type        = string
  default     = "default"
}


variable "project_level_iam_grants" {
  type = object({
    project_id = string
    iam_roles  = list(string)
  })

  default     = null
  description = "IAM roles to be assigned to this service account at project level."
}


variable "non_project_level_iam_grants" {
  type        = list(string)
  default     = []
  description = "IAM roles to be assigned to this service account not at project level."
}
