/*  If a cluster was deployed with private nodes then nodes will need to have acces to the Internet so they can pull Docker images.
    Therefore need to configure NAT gtw */

module "cloud_nat" {
  source = "path_to_the_tf-mod-gcp-cloud-nat_module_on_github"

  count = var.private_cluster.enabled ? 1 : 0

  cluster_name             = "gke-${var.cluster_name}-nat-router"
  region                   = local.region
  network_name             = data.google_compute_network.vpc.name
  subnetwork               = var.subnet.autocreate ? google_compute_subnetwork.vpc_subnet[0].id : local.subnet_id
  source_ip_ranges_to_nat  = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]
  secondary_ip_range_names = [for o_range in var.subnet.config.secondary_ip_range : o_range.range_name]
}
