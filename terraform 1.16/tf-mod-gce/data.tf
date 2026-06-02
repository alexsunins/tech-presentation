data "google_compute_image" "vm_image" {
  family  = var.machine_image.family
  project = var.machine_image.project
}
