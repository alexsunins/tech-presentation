# Terraform v1.16

Stuff that I have written in TF v1.16. Myself, without AI. Well before AI psychosis.

The modules demonstrate the use of different HCL language concepts (lists, mapping, dynamic blocks, etc) as well as overall structure.

Please note - this folder is solely for demonstrating the TF skills. Whilst some tools - e.g. ArgoCD - can be deployed using Helm, the purpose of this folder is to demonstrate how to achieve the same but solely in the TF domain. Also, sometimes Helm does not allow too granular cherry-picking of the tool arguments - a custom TF module that is maintained internally is a solution to this.

Also, implementation of aforementioned ArgoCD is rather bespoke as it deploys the app, an external IP address and secures the exposed endpoint with IAP.
