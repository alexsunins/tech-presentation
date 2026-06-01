#! /bin/zsh

# SYNOPSIS
#
# The script automates creation of service accounts that are required for an implementaion of `external-secrets` to work.
#
# The script excepts the following arguments to be passed in:
#
# 1. $k8_cluster_name -> the name of k8s cluster where to fetch the secrets from
# 2. $k8_namespace -> k8s namespace where to read the secrets from
# 3. $gcp_project -> GCP project where to add GCP SA to
# 4. $k8s namespace shorthand syntax -> the name of GSA is being formed based on the following template:
#
#       gsa-$k8_cluster_name-$k8_namespace-es
#
#    due to limitations of GCP Service Account names (8 to 33 chars long) the names of namespace like `development`, `production`, etc
#    will generate an error from `gcloud`. To overcome this `k8_namespace_short` argument was introduced and now the name of GSA is being formed
#    based on the following template:
#
#       gsa-$k8_cluster_name-$k8_namespace_short-es
#
# Environment where the script is run is expected to have `kubectl` and `gcloud` installed


# runtime checks
function print_and_exit(){
    printf '\n\n%s\n' $1
    exit 1
}

# check if all the expected arguments were passed in
expected_args=('k8s cluster name' 'k8s namespace' 'GCP project name (e.g. my-project)' 'k8s namespace shorthand syntax (e.g. dev, prod)')
for i in {1..$#expected_args}; do
    eval [ -z \$$i ] && print_and_exit "ERROR: no ${expected_args[$i]} was provided"
done

# check if `gcloud` and `kubectl` are installed
for app ('gcloud' 'kubectl') {
    app_version=$($app version 2>&1)
    [[ "$app_version" == *'not found'* ]] && print_and_exit "ERROR: $app not installed"
}

k8_cluster_name=$1
k8_namespace=$2
k8_namespace_short=$4
gcp_project=$3

gsa_name="gsa-$k8_cluster_name-$k8_namespace_short-es"

kubectl create serviceaccount external-secrets-ksa \
    --namespace $k8_namespace

gcloud iam service-accounts create $gsa_name \
    --project=$gcp_project

gcloud projects add-iam-policy-binding $gcp_project \
    --member "serviceAccount:$gsa_name@$gcp_project.iam.gserviceaccount.com" \
    --role "roles/secretmanager.secretAccessor"


gcloud iam service-accounts add-iam-policy-binding $gsa_name@$gcp_project.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$gcp_project.svc.id.goog[$k8_namespace/external-secrets-ksa]"
    
kubectl annotate sa external-secrets-ksa -n $k8_namespace iam.gke.io/gcp-service-account=$gsa_name@$gcp_project.iam.gserviceaccount.com