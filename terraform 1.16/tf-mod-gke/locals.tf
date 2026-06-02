locals {
  cluster_location = var.gke_zone
  region           = join("-", slice(split("-", var.gke_zone), 0, 2))
  subnet_id        = "projects/${var.project_id}/regions/${local.region}/subnetworks/${var.subnet.name}"

  enable_backup_for_gke      = contains(var.enable_cluster_features, "backup_for_gke")
  deploy_bastion_host        = var.private_cluster.enabled && contains(var.private_cluster.private_endpoint_access.ssh_through, "bastion-host")
  deploy_bastion_host_kproxy = var.private_cluster.enabled && contains(var.private_cluster.private_endpoint_access.ssh_through, "kubectl-proxy")

  master_authorized_networks = (
    local.deploy_bastion_host ?
    concat([{
      cidr_range  = "${module.bastion[0].internal_ip_addr}/32",
      description = "Bastion host for ${var.cluster_name} GKE cluster"
    }], var.private_cluster.master_authorized_networks) :
    var.private_cluster.master_authorized_networks
  )

  release_channel = var.release_channel == null ? [] : [{ channel : var.release_channel }]
  master_version  = var.kubernetes_version == "latest" ? data.google_container_engine_versions.master_version.latest_master_version : var.kubernetes_version
}
