# Variables related to the private GKE cluster

variable "private_cluster" {
  type = object({
    enabled                 = bool
    disable_public_endpoint = bool
    master_ipv4_cidr_block  = string
    master_authorized_networks = list(object({
      cidr_range  = string
      description = string
    }))
    private_endpoint_access = object({
      ssh_through = list(string)
      ssh_allow   = list(string)
    })
  })

  description = <<EOD
    A private cluster is a type of VPC-native cluster that only depends on internal IP addresses.

    Private clusters use nodes that do not have external IP addresses.

    Unlike a public cluster, a private cluster has both a control plane private endpoint and a control plane public endpoint.
    You must specify a unique /28 IP address range for the control plane's private endpoint, and you can choose to disable the control plane's public endpoint.

    enabled = If true, enables the private cluster feature, creating a private endpoint on the cluster.
      In a private cluster, nodes only have RFC 1918 private addresses and communicate with the master's private endpoint via private networking.
    
    disable_public_endpoint =  When true, the cluster's private endpoint is used as the cluster endpoint and
      access through the public endpoint is disabled. When false, either endpoint can be used and the authorized networks apply to the control plane's public endpoint.
    
    master_ipv4_cidr_block = The IP range in CIDR notation to use for the hosted master network.
      This range will be used for assigning private IP addresses to the cluster master(s) and the ILB VIP.
      This range must not overlap with any other ranges in use within the cluster's network, and it must be a /28 subnet.
      You can use any of the following CIDRs 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
        NOTE: When you use 172.17.0.0/16 for your control plane IP range, you cannot use this range for nodes, Pod, or Services IP addresses.

    master_authorized_networks = Specify the list of CIDRs which can access the master's API.  This can be a list of up to 50 CIDRs.
      It's basically a control plane firewall rulebase. Nodes automatically/always have access, so these are for users and automation systems.
    
    private_endpoint_access = a private cluster has both a public and a private endpoint. If the public endpint is enabled then access to the cluster's
      control plane is controlled by the list of master authorised networks. Access to the control plane via the private endpoint
      is possible via bastion host which either serves as a proxy for kubectl calls from localhost or is used to ssh in and then run kubectl commands from
      the bastion host.

      ssh_through = this list can contain the following items:
        bastion-host  - GCE instance will be deployed and have kubectl installed. Users will be required to ssh in, authenticate themselves using
                        gcloud auth login and then run kubectl commands from this host.
        kubectl-proxy - GCE instance will be deployed and have tinyproxy installed. Users then will be required to establish SSH tunnel from localhost to the instance
                        and will be able to run kubectl commands from localhost, the instance will proxy kubectl call to the GKE cluster.

      ssh_allow = access to the instance over ssh is secured with IAP. This list should have email addresses of users that will be allowed to connect to the aforementioned hosts over SSH.
  EOD

  default = {
    enabled                    = false
    disable_public_endpoint    = false
    master_ipv4_cidr_block     = "172.16.0.32/28"
    master_authorized_networks = null
    private_endpoint_access = {
      ssh_through = []
      ssh_allow   = []
    }
  }
}

