data "google_compute_zones" "available" {
  region = var.region
}


data "google_compute_network" "default" {
  name = var.network
}
