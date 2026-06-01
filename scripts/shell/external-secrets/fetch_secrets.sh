#! /bin/zsh

# SYNOPSIS
#
# The script will pull the existing secrets from k8s and create these secrets in GCP Secrets Manager.
# The name of each secret will be made up from $1 and $2, such as
#
# '$1-$2-$(k8s secret name)'
#
# Therefore, the script excepts two arguments to be passed in:
#
# $1 -> the name of k8s cluster where to fetch the secrets from
# $2 -> k8s namespace where to read the secrets from
#
# Environment where the script is executed is expected to have `kubectl` and `gcloud` installed

# runtime checks
function print_and_exit(){
    printf '\n\n%s\n' $1
    exit 1
}

# check if all the expected arguments were passed in
expected_args=('k8s cluster name' 'namespace')
for i in {1..$#expected_args}; do
    eval [ -z \$$i ] && print_and_exit "ERROR: no ${expected_args[$i]} was provided"
done

# check if `gcloud` and `kubectl` are installed
for app ('gcloud' 'kubectl') {
    app_version=$($app version 2>&1)
    [[ "$app_version" == *'not found'* ]] && print_and_exit "ERROR: $app not installed"
}


#set -e -o pipefail


## -=-== VARIABLES ==-=- ##
namespace=$2
cluster_name=$1
temp_file_path='/tmp/secret.txt'
parser_error='NULL'
success=0
failure=1
script_name=$(basename $0 | sed 's/\.sh//')
template_folder='./templates'
template_name='template.externalSecret.yaml'
template_path="$template_folder/$template_name"

# check if the required YAML template exists
[ -f $template_path ] || print_and_exit "ERROR: $template_path was not found"


## -=-== FUNCTIONS ==-=- ##
function prep_manifest(){
    # $1 -> secret_name
    # $2 -> gsm_secret_name

    while IFS= read -r line; do
        [[ "$line" == *'_name'* ]] && line=$(echo "$line" | sed "s/_name/$1/" )
        [[ "$line" == *'_gcpsm'* ]] && line=$(echo "$line" | sed "s/_gcpsm/$2/" )

        echo "$line" >> $1.externalSecret.yaml 
    done < $template_path
}


function add_secret_to_gsm(){
    # $1 -> secret name
    # $2 -> secret value

    printf $2 > $temp_file_path
    
    gcloud secrets create $1 --replication-policy="automatic"
    gcloud secrets versions add $1 --data-file=$temp_file_path

    cat $temp_file_path

    rm $temp_file_path
}


function build_json(){

    # get .data map keys
    kubectl_output=$(kubectl get secrets/$1 -n $namespace -o 'go-template={{ range $key, $value := .data }}{{$key}} {{end}}' | xargs)

    IFS=' ', read -rA data_keys <<< "$kubectl_output"

    data_keys_len=${#data_keys[@]}


    # build an array by reading and decoding the map values
    declare -A data_arr

    parse_result=0
    for k ("$data_keys[@]") {
        data_arr[$k]=$(kubectl get secrets/$1 -n $namespace --template={{.data.$k}} | base64 -D)

        [[ $data_arr[$k] == '' ]] && parse_result=$failure # will get back empty string if there is an error from `kubectl` parser
    }


    [[ $parse_result == $success ]] && {
        # build JSON body
        idx=0
        json_body=''

        for k ("$data_keys[@]") {
            idx=$((idx + 1))
            [ $idx -eq $data_keys_len ] && eol_char='' || eol_char=','
            json_body=$(printf '%s\n\t"%s": "%s"%s' "$json_body" $k $data_arr[$k] $eol_char)
        }

        json_body=$(printf '{%s\n}\n' $json_body)
    } || json_body=$parser_error

    echo "$json_body"
}

## -=-== MAIN LOOP ==-=- ##
secrets_to_decode_manually=()
for secret_name in $(kubectl get secrets -n $namespace -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'); do
    gsm_secret_name="$cluster_name-$namespace-$secret_name"

    printf '\n\n\t%s\n' "$script_name: fetching data block of $secret_name"
    
    json_body=$(build_json $secret_name)

    [[ $json_body == $parser_error ]] && {
        echo "ERROR: Unable to decode $secret_name"
        secrets_to_decode_manually+=($secret_name)
    } || {
        echo "Preparing manifest for ExternalSecret object"
        prep_manifest $secret_name $gsm_secret_name

        echo "Adding the secret to GCP"
        add_secret_to_gsm $gsm_secret_name $json_body
    }
done

printf '\n\n%s\n\n' "The following secrets were not retrieved:"
for secret ("$secrets_to_decode_manually[@]") print $secret
