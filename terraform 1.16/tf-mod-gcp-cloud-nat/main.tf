resource "google_compute_router" "router" {
  name    = "${local.nat_router_name_prefix}-nat-router"
  region  = var.region
  network = var.network_name
}


resource "google_compute_address" "nat_gateway_static_ip" {
  depends_on = [
    google_compute_router.router
  ]

  name   = "${local.nat_router_name_prefix}-nat-gw-static-ip"
  region = var.region
}


resource "google_compute_router_nat" "nat_gateway" {
  depends_on = [
    google_compute_address.nat_gateway_static_ip
  ]

  name   = "${local.nat_router_name_prefix}-nat-gateway"
  router = google_compute_router.router.name
  region = google_compute_router.router.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = google_compute_address.nat_gateway_static_ip.*.self_link

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                     = var.subnetwork
    source_ip_ranges_to_nat  = var.source_ip_ranges_to_nat
    secondary_ip_range_names = local.add_secondary_ip_range_names ? var.secondary_ip_range_names : null
  }
}

