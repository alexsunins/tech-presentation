module "node_pool" {
  depends_on = [google_container_cluster.gke_cluster]

  source = "./modules/google_container_node_pool"

  name = var.node_pool.name

  gke_cluster = {
    name                          = google_container_cluster.gke_cluster.name
    location                      = local.cluster_location
    service_account_email_address = module.gke_cluster_sa.email
  }

  node_count = var.node_pool.node_count

  image_type   = var.node_pool.image_type
  machine_type = var.node_pool.machine_type

  autoscaling = var.autoscaling
}
