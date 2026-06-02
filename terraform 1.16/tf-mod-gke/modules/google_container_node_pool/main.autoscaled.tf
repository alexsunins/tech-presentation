resource "google_container_node_pool" "gke_cluster_nodes_autoscaled" {
  count = var.autoscaling == null ? 0 : 1

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

  autoscaling {
    min_node_count = var.autoscaling.nodes.min
    max_node_count = var.autoscaling.nodes.max
  }


  lifecycle {
    ignore_changes = [node_count]
  }
}
