#! /bin/bash

set -e

function join(){
    local IFS="$1"
    shift
    echo "$*"
}

printf '\n\t%s\n\n' '---------- BUILDING DOCKER IMAGE ----------'

# ARGUMENTS:
# $1 - application name
# $2 - country code, e.g. uk, us, etc
# $3 - environment type. To build and tag with `latest` and push to dev call the script using $1 -> ./Docker-build.sh dev
# $4 - commit sha1. If present then the image will be tagged with the commit sha1. This will be added by Cloudbuild

arg_names=( 'App name' 'Country code' 'Environment type' )

# SHA commit is expected at positon len(arg_names) + 1
sha_commit_arg_position=$(expr ${#arg_names[@]} + 1)
eval [ -z  \$$sha_commit_arg_position ] && expected_no_of_args=${#arg_names[@]} || expected_no_of_args=$sha_commit_arg_position

[[ $# -eq 0 ]] || [[ $# -ne $expected_no_of_args ]] && {
    printf '\n\n%s\n\n' "ERROR > Expected arguments: ${#arg_names[@]} [ $(join '|' "${arg_names[@]}" ) ], Provided: $#"
    exit 1
}

APP_NAME=$1
COUNTRY_CODE=$2
ENV_TYPE=$3

# if SHA1 is passed in then add it to the Docker image tags
eval [ -z \$${sha_commit_arg_position} ] || IMAGE_TAGS="$IMAGE_TAGS -t $APP_NAME:$(eval echo \$${sha_commit_arg_position})"


# Artifact Registry arguments
AR_LOCATION="europe-west2" PROJECT_ID="my-gcp-project" REPOSITORY="k8s-docker-images"

# Docker image arguments
IMAGE_VERSION="latest" IMAGE_TAGS="$APP_NAME:$IMAGE_VERSION" \
IMAGE_DESTINATION="$AR_LOCATION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$APP_NAME/$ENV_TYPE/$COUNTRY_CODE:$IMAGE_VERSION"

CLI_STR="docker build --pull --no-cache --platform linux/amd64 -t $IMAGE_TAGS ."

eval $CLI_STR && docker tag $APP_NAME:$IMAGE_VERSION $IMAGE_DESTINATION