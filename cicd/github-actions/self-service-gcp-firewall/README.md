# self-service-gcp-firewall

If developers are working from home then their external IP address can change frequently.
Whilst the devs can come to DevOps and ask to add new IP addresses to allow access to the cloud services, many frequent requests will create administration overhead. This custom tool was put together to enable devs to self-service the firewall access.

The idea is simple: a dev edits a file, adds their IP address and then commits the change to GH. GH workflow kicks in and runs a cron job in GKE that fetches the latest changes in the repository and removes existing firewall rules and re-applies the rules but with the latest info from the edited files.

The repository contains individual IP addresses to allow through the GCP firewall.

GCP allows incremental edits to a rule. In order to allow to add and remove source ranges need to delete the existing rule and create a new rule.

Source ranges (including CIDR) are found in `ip.list` file. The file is kept in `FolderA/FolderB` where `FolderA` is the name of VPC network for which the rule will apply and `FolderB` is the port number. Empty `ip.list` file will be ignored.
