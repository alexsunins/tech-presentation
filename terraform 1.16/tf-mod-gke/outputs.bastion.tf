output "bastion_internal_ip_addr" {
  value = {
    bastion = local.deploy_bastion_host ? module.bastion[0].internal_ip_addr : null,
    kproxy  = local.deploy_bastion_host_kproxy ? module.kubectl_proxy[0].internal_ip_addr : null
  }
}


output "ssh_connection_string" {
  value = {
    bastion = local.deploy_bastion_host ? module.bastion[0].ssh_connection_string : null,
    kproxy  = local.deploy_bastion_host_kproxy ? module.kubectl_proxy[0].ssh_connection_string : null,
  }
}
