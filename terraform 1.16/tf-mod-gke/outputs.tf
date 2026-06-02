output "gke_cluster_id" {
  description = "GKE Cluster ID."
  value       = google_container_cluster.gke_cluster.id
}


output "gke_cluster_name" {
  description = "GKE Cluster Name."
  value       = google_container_cluster.gke_cluster.name
}


output "gke_master_version" {
  description = "GKE Master version."
  value       = google_container_cluster.gke_cluster.master_version
}


output "gke_cluster_location" {
  description = "GKE Cluster location."
  value       = google_container_cluster.gke_cluster.location
}


output "gke_node_pool_name" {
  description = "GKE Node pool name"
  value       = var.node_pool.name
}


output "gke_cluster_endpoint" {
  description = "The IP address of the GKE cluster master."
  value       = google_container_cluster.gke_cluster.endpoint
}


output "gke_cluster_ca_certificate" {
  description = "Base64 encoded public certificate that is the root of trust for the cluster."
  value       = base64decode(google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate)
}


output "gke_cluster_sa_email_address" {
  description = "Email address for the cluster's service account."
  value       = module.gke_cluster_sa.email
}


output "gke_connection_string" {
  value = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.gke_zone} --project ${var.project_id}"
}


output "gke_connection_string_private_endpoint" {
  value = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.gke_zone} --project ${var.project_id} --internal-ip"
}
