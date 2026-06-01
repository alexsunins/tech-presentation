#! /bin/bash

set -e

function join(){
    local IFS="$1"
    shift
    echo "$*"
}

printf '\n\t%s\n\n' '---------- PUSHING DOCKER IMAGE ----------'

# ARGUMENTS:
# $1 - application name
# $2 - country code, e.g. uk, us, etc
# $3 - environment type. To build and tag with `latest` and push to dev call the script using $1 -> ./Docker-build.sh dev


arg_names=( 'App name' 'Country code' 'Environment type' )

[[ $# -eq 0 ]] || [[ $# -ne ${#arg_names[@]} ]] && {
    printf '\n\n%s\n\n' "ERROR > Expected arguments: ${#arg_names[@]} [ $(join '|' "${arg_names[@]}" ) ], Provided: $#"
    exit 1
}

APP_NAME=$1
COUNTRY_CODE=$2
ENV_TYPE=$3

# Artifact Registry arguments
AR_LOCATION="europe-west2" PROJECT_ID="my-gcp-project" REPOSITORY="k8s-docker-images"

# Docker image arguments
IMAGE_VERSION="latest" IMAGE_TAGS="$APP_NAME:$IMAGE_VERSION" \
IMAGE_DESTINATION="$AR_LOCATION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$APP_NAME/$ENV_TYPE/$COUNTRY_CODE:$IMAGE_VERSION"

docker push $IMAGE_DESTINATION