resource "google_container_node_pool" "gke_cluster_nodes_static" {
  count = var.autoscaling == null ? 1 : 0

  name       = var.name
  location   = var.gke_cluster.location
  cluster    = var.gke_cluster.name
  node_count = var.node_count

  node_config {
    image_type   = var.image_type
    machine_type = var.machine_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = var.gke_cluster.service_account_email_address
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    metadata = {
      // Explicitly remove GCE legacy metadata API endpoint.
      disable-legacy-endpoints = true
    }

    labels = var.labels
  } // endof node_config block

  management {
    auto_upgrade = true
    auto_repair  = true
  }

  # upgrade_settings {
  #   max_surge       = 1
  #   max_unavailable = 1
  # }
}
