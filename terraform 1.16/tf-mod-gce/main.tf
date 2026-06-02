resource "google_compute_disk" "disk" {
  count = var.additional_disk == null ? 0 : 1

  name                      = local.additional_disk.name
  physical_block_size_bytes = 4096
  project                   = var.project_id
  size                      = local.additional_disk.size
  type                      = "pd-standard"
  zone                      = var.zone
}


resource "google_compute_instance" "vm" {
  depends_on = [
    module.gce_instance_sa
  ]

  name                      = var.vm_name
  project                   = var.project_id
  zone                      = var.zone
  machine_type              = var.machine_type
  allow_stopping_for_update = true

  dynamic "attached_disk" {
    for_each = var.additional_disk == null ? [] : [1]
    content {
      device_name = local.additional_disk.name
      mode        = "READ_WRITE"
      source      = google_compute_disk.disk[0].self_link
    }
  }

  boot_disk {
    auto_delete = true
    device_name = "${var.vm_name}-boot-disk"
    mode        = "READ_WRITE"

    initialize_params {
      image = data.google_compute_image.vm_image.self_link
      size  = var.boot_disk_size
      type  = "pd-standard"
    }
  }

  labels = var.labels

  network_interface {
    dynamic "access_config" {
      for_each = var.external_static_ip_address.reserve_and_attach == false ? [] : [1]
      content {
        nat_ip = google_compute_address.ext_static_ip[0].address
      }
    }

    network            = var.network
    subnetwork         = var.subnetwork
    subnetwork_project = var.project_id
  }

  reservation_affinity {
    type = "ANY_RESERVATION"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  service_account {
    email  = local.service_account_email
    scopes = var.service_account_scopes
  }

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }

  metadata_startup_script = var.metadata_startup_script

  metadata = {
    block-project-ssh-keys = true
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      metadata["ssh-keys"],
      attached_disk,
      boot_disk,
      metadata_startup_script,
      boot_disk.0.initialize_params
    ]
  }
}
