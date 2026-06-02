# tf-mod-gcp-cloudsql-vpc-peering
TF module that creates peering between a VPC and CloudSQL VPC.


Cloud SQL supports private IP addresses through private service access.

Private services access is implemented as a VPC peering connection between your VPC network and the underlying Google Cloud VPC network where your Cloud SQL instance resides. The private connection enables VM instances in your VPC network and the services that you access to communicate exclusively by using internal IP addresses. VM instances don't need Internet access or external IP addresses to reach services that are available through private services access.

When you create a Cloud SQL instance, Cloud SQL creates the instance within its own virtual private cloud (VPC), called the Cloud SQL VPC. Enabling private IP requires setting up a peering connection between the Cloud SQL VPC and your VPC network. This allows resources in your VPC network to access the internal IP addresses of your Cloud SQL resources in the Cloud SQL VPC network.
