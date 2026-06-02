# tf-mod-gke
TF module for deploying a GKE cluster.

TF module can deploy VPC-Native and route based clusters.

TF module also supports deploying a private cluster which is a type of VPC-Native cluster.

If access to the cluster's external endpoint needs to be restricted then the module can be used to add members to the cluster's master authorised networks. Also, the module can deploy a bastion host that can act as a jump box or `kubectl` API call forwarder.

The module also provides an option to deploy a backup plan.
