output "ingress_ip_address" {
  description = "The value of google_compute_global_address.argocd_global_ip_address"
  value       = google_compute_global_address.argocd_global_ip_address.address
}
