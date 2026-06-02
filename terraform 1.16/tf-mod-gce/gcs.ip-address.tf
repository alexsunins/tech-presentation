resource "google_compute_address" "ext_static_ip" {
  count = var.external_static_ip_address.reserve_and_attach == false ? 0 : 1
  name  = "${var.vm_name}-ipv4-address"
}
