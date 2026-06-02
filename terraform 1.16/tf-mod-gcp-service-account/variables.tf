variable "service_account_name" {
  description = "The name for the GCP service account. If null then the name will be generated from var.service_account_name_prefix and var.service_account_name_suffix_length"
  type        = string
  default     = null
}


variable "service_account_name_prefix" {
  description = "Prefix for the service account name. Used if var.service_account_name is null"
  type        = string
  default     = null
}


variable "service_account_name_suffix_length" {
  description = "Length of the service account name suffix"
  type        = number
  default     = 8
}


variable "service_account_description" {
  description = "Description of the service account"
  type        = string
  default     = ""
}


variable "display_name" {
  type        = string
  default     = ""
  description = "Display name of the service account"
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
