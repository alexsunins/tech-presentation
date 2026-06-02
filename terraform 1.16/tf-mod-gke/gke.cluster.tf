# Create Subnet if required
resource "google_compute_subnetwork" "vpc_subnet" {
  count   = var.subnet.autocreate ? 1 : 0
  name    = var.subnet.name
  region  = local.region
  network = data.google_compute_network.vpc.name

  ip_cidr_range = var.subnet.config.ip_cidr_range

  dynamic "secondary_ip_range" {
    for_each = var.subnet.config.secondary_ip_range
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}


resource "google_container_cluster" "gke_cluster" {
  depends_on = [
    module.gke_cluster_sa,
    module.bastion
  ]

  provider = google-beta // for pod_security_policy_config block

  name = var.cluster_name

  location = local.cluster_location

  network    = data.google_compute_network.vpc.id
  subnetwork = var.subnet.autocreate ? google_compute_subnetwork.vpc_subnet[0].id : local.subnet_id

  dynamic "release_channel" {
    for_each = local.release_channel

    content {
      channel = release_channel.value.channel
    }
  }

  min_master_version = var.release_channel == null ? local.master_version : null

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  remove_default_node_pool = true
  initial_node_count       = 1


  private_cluster_config {
    enable_private_nodes    = var.private_cluster.enabled
    enable_private_endpoint = var.private_cluster.disable_public_endpoint
    master_ipv4_cidr_block  = var.private_cluster.master_ipv4_cidr_block
  }

  dynamic "master_authorized_networks_config" {
    for_each = var.private_cluster.master_authorized_networks == null ? [] : [1]
    content {
      dynamic "cidr_blocks" {
        for_each = toset(local.master_authorized_networks)
        content {
          cidr_block   = cidr_blocks.value.cidr_range
          display_name = cidr_blocks.value.description
        }
      }
    }
  }


  networking_mode = var.vpc_native.enabled ? "VPC_NATIVE" : "ROUTES"

  dynamic "ip_allocation_policy" {
    for_each = var.vpc_native.ip_allocation == null ? [] : [1]
    content {
      cluster_secondary_range_name  = var.vpc_native.ip_allocation.cluster_secondary_range_name
      services_secondary_range_name = var.vpc_native.ip_allocation.services_secondary_range_name
    }
  }


  // Required for Calico, optional otherwise.
  // Configuration options for the NetworkPolicy feature
  network_policy {
    enabled  = var.disable_network_policy_config ? false : true
    provider = var.disable_network_policy_config ? "PROVIDER_UNSPECIFIED" : "CALICO" // CALICO is currently the only supported provider (as of 2022-12-13)
  }

  // Required for network_policy enabled cluster, optional otherwise
  // Addons config supports other options as well, see:
  // https://www.terraform.io/docs/providers/google/r/container_cluster.html#addons_config
  addons_config {
    network_policy_config {
      disabled = var.disable_network_policy_config
    }

    gke_backup_agent_config {
      enabled = local.enable_backup_for_gke
    }

    istio_config {
      disabled = !var.istio_addon.enabled
      auth     = var.istio_addon.auth
    }
  }

  pod_security_policy_config {
    enabled = var.enable_pod_security_policy_config
  }

  # VPA config
  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  dynamic "maintenance_policy" {
    for_each = contains(var.enable_cluster_features, "maintenance") ? [1] : []

    content {
      dynamic "daily_maintenance_window" {
        for_each = var.daily_maintenance_window == null ? [] : [1]

        content {
          start_time = var.daily_maintenance_window.start_time
        }
      }

      dynamic "recurring_window" {
        for_each = var.recurring_maintenance_window == null ? [] : [1]

        content {
          start_time = var.recurring_maintenance_window.start_time
          end_time   = var.recurring_maintenance_window.end_time
          recurrence = var.recurring_maintenance_window.recurrence
        }
      }
    }
  }

  dynamic "authenticator_groups_config" {
    for_each = var.google_groups_for_rbac == null ? [] : [1]
    content {
      security_group = var.google_groups_for_rbac.security_group_email_address
    }
  }

  resource_labels = var.labels

  deletion_protection = var.protect_from_accidental_deletion
}
