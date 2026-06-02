variable "namespace" {
  type        = string
  description = "Namespace where to deploy the app"
}


variable "app_version" {
  type        = string
  default     = "v1.0.2"
  description = "Version of the app to deploy"
}


