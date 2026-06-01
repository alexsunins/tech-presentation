# external-secrets

Helper scripts for the implementation of [`external-secrets`](https://external-secrets.io/latest/).

Normally External Secrets is used to bring secrets from a cloud provider to Kubernetes.
This script was written for the reverse process - when you need to push secrets from a k8s cluster to a cloud provider (in this example, GCP) and also create a ES template for each discovered secret. Such scenario can happen when migrating a Kubernetes cluster.

The scripts also demonstrate the use of arrays, loops and ratio between code readability vs code complexity.

The scripts were written and tested by me well before AI psychosis.


## `fetch_secrets.sh`

This script automates the process of reading the `k8s` secrets and adding the secrets to GCP Secrets Manager.

*Please make sure you switch to the required `k8s` context before running the script.*

The script expects two arguments to be passed in:

```bash
$1 - the name of k8s cluster
$2 - the name of the namespace to read the secrets from
```

The name of a secret in GCP will be made up of these two arguments, so that

```bash
$1-$2-$(k8s-secret-name)
```

The sript will also provision a manifest for the `ExternalSecret` objects which can be applied by running `kubectl apply -f ...` . The template for the manifest is kept under `./templates`

Any secrets that can't be decoded (for example, if a secret contains a private key of JSON structure) will be skipped and at the end of its run the script will output the names of the secrets that require manual decoding.
