# tf-mod-k8s-resource
TF module that deploys a `k8s` resource from a YAML manifest.
Sometimes you need to deploy a k8s manifest using Terraform. This is what this module is for.

## Requirements

`gavinbunney/kubectl`

## Inputs

`manifest` - manifests contents in YAML format.

`wait_after_create` - some resources require `time_sleep` before then can be queried, for example Ingress. `wait_after_create` takes time parameter in string format - e.g. `10s`, `300s`, etc.
