#! /bin/zsh

function get_roles(){
    gcloud projects get-iam-policy my-project  \
    --flatten="bindings[].members" \
    --format='table(bindings.role)' \
    --filter="bindings.members:$1"
}

while read -r line; do
    line=$(echo $line | sed -E 's/[[:space:]]+/:/')
    instance_data=( ${(@s/:/)line} )

    instance_name=$instance_data[1]
    instance_sa=$instance_data[2]

    [[ -z $instance_sa ]] || {
        iam_roles=$(get_roles $instance_sa)
        printf '%s ~> %s\n%s\n\n' $instance_name $instance_sa $iam_roles
    }
    
done <<<$(gcloud compute instances list --project=my-gcp-project --format='table(name,serviceAccounts[0].email)' --sort-by="serviceAccounts[0].email" | tail -n +2)
