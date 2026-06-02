output "loadbalancer_ip_address" {
  description = "The value of the external IP address for ArgoCD"
  value       = var.expose_services ? module.argocd_networking[0].ingress_ip_address : null
}
