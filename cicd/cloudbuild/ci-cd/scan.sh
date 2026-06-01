#! /bin/bash

# $1 - whether to run the scan, true or false
# $2 - the name of an image to scan

printf '\n\t%s\n\n' '---------- VULNERABILITIES ----------'

TOGGLE=$(echo $1 | tr '[:upper:]' '[:lower:]')
for mode in 'true' 'false'; do [[ $TOGGLE == $mode ]] && toggle_scan=$mode; done

[ -z $toggle_scan ] &&  {
    printf '\n%s\n' "ERROR: Unknown argument -> $1"
    exit 1
}

[[ $toggle_scan == 'false' ]] && {
    echo 'Vulnerability scan DISABLED'
    exit 0
}

echo "Vulnerability scan ENABLED"

printf '\n\t%s\n\n' '---------- SCANNING DOCKER IMAGE ----------'

IMAGE_NAME=$2
[ -z $IMAGE_NAME ] && {
    printf '\n%s\n\n' 'ERROR: Docker image name not passed'
    exit 1
} || echo "Scanning image $IMAGE_NAME"

# The first run requires downloading DB
printf '\n\t%s\n\n' '---------- UPDATING SCANNER DB ----------'
trivy image --download-db-only

printf '\n\t%s\n\n' '---------- SCANNING FOR ALL KNOWN VULNERABILITES ----------'
trivy image --exit-code 0 --security-checks vuln --vuln-type library --no-progress $IMAGE_NAME # scan for all vulnerabilites...

printf '\n\t%s\n\n' '---------- SCANNING FOR CRITICAL VULNERABILITES ----------'
trivy image --exit-code 1 --security-checks vuln --vuln-type library --severity CRITICAL --no-progress $IMAGE_NAME # ...and fail the pipeline if CRITICAL vulnerabilites are discovered