variable "argocd_namespace" {
  description = "The name of k8s namespace where to deploy argocd. If set to `null` then defaults to `argocd`"
  type        = string
}


variable "argocd_external_ip_name" {
  description = "The name of the external IP address for Ingress"
  type        = string
}


variable "argocd_regional_ip" {
  type = object({
    name   = string
    region = string
  })

  default = null

  description = <<EOL
    The name and a region for the regional IP address (for LB service type)

    name    => name
    region  => region, must match GKE cluster region
  EOL
}


variable "dns_name" {
  description = "FQDN for Google Managed Certificate"
  type        = string
}


variable "ingress_wait_time" {
  description = "How long to wait for k8s ingress to be created"
  type        = string
  default     = "180s"
}


variable "secure_with_iap" {
  type = object({
    client_id     = string
    client_secret = string
  })

  default     = null
  description = "If not null will add IAP annotation to argocd-server service"
}
