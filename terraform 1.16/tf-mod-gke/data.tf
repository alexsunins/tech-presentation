data "google_container_engine_versions" "master_version" {
  location = local.cluster_location
  project  = var.project_id
}


# Get VPC config
data "google_compute_network" "vpc" {
  name = var.network_name
}
