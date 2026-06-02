locals {
  additional_disk = {
    name = var.additional_disk == null ? "${var.vm_name}-logical-disk" : var.additional_disk.name
    size = var.additional_disk == null ? 10 : var.additional_disk.size
  }

  service_account_email = var.service_account_email == null ? module.gce_instance_sa.email : var.service_account_email
}
