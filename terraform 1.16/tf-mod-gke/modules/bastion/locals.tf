locals {
  instance_sa_permissions = var.host_type == "bastion-host" ? ["roles/container.clusterViewer"] : []
  instance_ip_addr_name   = var.host_type == "bastion-host" ? var.host_type : "kubectl-proxy"
  instance_description    = var.host_type == "bastion-host" ? "bastion host" : "IAP-backed kubectl proxy"
  instance_zone           = data.google_compute_zones.available.names[0]
  cluster_name            = var.cluster_name_alias_for_bastion_service_account == null ? var.cluster_name : var.cluster_name_alias_for_bastion_service_account
  intance_name            = var.host_type == "bastion-host" ? "gke-${local.cluster_name}-bastion" : "gke-${local.cluster_name}-kproxy"
}
