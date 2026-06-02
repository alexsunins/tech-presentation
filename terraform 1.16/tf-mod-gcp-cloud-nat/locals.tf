locals {
  nat_router_name_prefix       = var.cluster_name == null ? var.subnetwork : "gke-${var.cluster_name}"
  add_secondary_ip_range_names = contains(var.source_ip_ranges_to_nat, "LIST_OF_SECONDARY_IP_RANGES")
}
