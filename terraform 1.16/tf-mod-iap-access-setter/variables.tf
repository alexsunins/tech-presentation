variable "project_id" {
  type        = string
  description = "GCP Project ID"
}


variable "web_service" {
  type = object({
    name      = string
    namespace = string
  })
  description = "The name of IAP-protected web service and its k8s namespace"
}


variable "user_access_list" {
  type = list(object({
    entity        = string
    email_address = string
  }))
  description = <<EOF
    A list of users to apply access to.

    entity => one of user, group, serviceAccount
    email_address => a digstinguished email address for the entity
  EOF
}


variable "port_name" {
  type        = number
  description = "(OPTIONAL) Port number of the web service. Defaults to 80"
  default     = 80
}
