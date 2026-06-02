resource "random_id" "id" {
  byte_length = 2
}


resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta

  name          = "cloudsql-vpc-peering-private-ip-${random_id.id.hex}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network_id
}


resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}
