module "bastion" {
  source = "./modules/bastion"

  count = contains(var.private_cluster.private_endpoint_access.ssh_through, "bastion-host") ? 1 : 0

  host_type                                      = "bastion"
  project                                        = var.project_id
  region                                         = local.region
  cluster_name                                   = var.cluster_name
  cluster_name_alias_for_bastion_service_account = var.cluster_name_alias_for_bastion_service_account
  network                                        = var.network_name
  subnetwork                                     = var.subnet.autocreate ? google_compute_subnetwork.vpc_subnet[0].id : local.subnet_id
  ssh_allow                                      = var.private_cluster.private_endpoint_access.ssh_allow
}


module "kubectl_proxy" {
  source = "./modules/bastion"

  count = contains(var.private_cluster.private_endpoint_access.ssh_through, "kubectl-proxy") ? 1 : 0

  host_type                                      = "kubectl-proxy"
  project                                        = var.project_id
  region                                         = local.region
  cluster_name                                   = var.cluster_name
  cluster_name_alias_for_bastion_service_account = var.cluster_name_alias_for_bastion_service_account
  network                                        = var.network_name
  subnetwork                                     = var.subnet.autocreate ? google_compute_subnetwork.vpc_subnet[0].id : local.subnet_id
  ssh_allow                                      = var.private_cluster.private_endpoint_access.ssh_allow
}

