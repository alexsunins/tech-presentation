resource "google_compute_address" "internal_ip" {
  project      = var.project
  address_type = "INTERNAL"
  region       = var.region
  subnetwork   = var.subnetwork
  name         = "gke-${var.cluster_name}-${local.instance_ip_addr_name}-ip"
  description  = "An internal IP address for ${local.instance_description} for ${var.cluster_name} GKE cluster"
}


module "instance_sa" {
  source = "<path_to_the_tf-mod-gcp-service-account_module_on_github>"

  project_id                  = var.project
  service_account_name        = "${local.intance_name}-sa"
  service_account_description = "Service account for ${local.instance_description} for ${var.cluster_name} GKE cluster"
  service_account_iam_roles   = local.instance_sa_permissions
}


resource "google_compute_instance" "instance" {
  project      = var.project
  zone         = local.instance_zone
  name         = local.intance_name
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    network_ip = google_compute_address.internal_ip.address
  }

  metadata_startup_script = file("${path.module}/scripts/${var.host_type}_startup_script.sh")

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = module.instance_sa.email
    scopes = ["cloud-platform"]
  }

  lifecycle {
    ignore_changes = [metadata["ssh-keys"]]
  }
}


resource "google_compute_firewall" "instance_iap_allow" {
  project = var.project
  name    = "${var.cluster_name}-allow-${local.instance_ip_addr_name}-tunnel-ssh"
  network = data.google_compute_network.default.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] # IAP changes the source traffic to 35.235.240.0/20 and the tunnel to https://tunnel.cloudproxy.app.
}
