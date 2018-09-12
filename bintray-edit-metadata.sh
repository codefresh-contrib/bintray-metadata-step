#!/bin/bash

mainloop(){
   
    echo "[BINTRAY INFO] Checking credentials"
    http --ignore-stdin --headers --check-status -a $BINTRAY_USER:$BINTRAY_TOKEN GET https://api.bintray.com/users/$BINTRAY_USER
    if [ $? -gt 0 ]; then
        echo "[BINTRAY ERROR] wrong credentials"
        exit $?
    fi
    
    #Updating description
    echo "[BINTRAY EDIT] Changing package description"
    http --ignore-stdin -v --check-status -a $BINTRAY_USER:$BINTRAY_TOKEN PATCH https://api.bintray.com/packages/$BINTRAY_USER/docker/$DOCKER_IMAGE desc="Custom metadata set by $CF_BUILD_URL" vcs_url=http://codefresh.io

    #Updating project labels
    echo "[BINTRAY EDIT] Changing package labels"
    http --ignore-stdin -v --check-status -a $BINTRAY_USER:$BINTRAY_TOKEN PATCH https://api.bintray.com/packages/$BINTRAY_USER/docker/$DOCKER_IMAGE labels:='["first", "second"]'

    #Sample Readme
    echo "[BINTRAY EDIT] Changing package readme"
    http -v --check-status -a $BINTRAY_USER:$BINTRAY_TOKEN POST  https://api.bintray.com/packages/$BINTRAY_USER/docker/$DOCKER_IMAGE/readme < file-content-template.json

    #Updating project attributes
    echo "[BINTRAY EDIT] Changing package attributes"
    echo '[{"name": "Codefresh1", "values": ["64.0"]},{"name":"Codefresh2","values":["one","two"]}]' | http -v --check-status -a $BINTRAY_USER:$BINTRAY_TOKEN POST https://api.bintray.com/packages/$BINTRAY_USER/docker/$DOCKER_IMAGE/attributes

    #Sample release notes
    echo "[BINTRAY EDIT] Changing version release notes"
    http -v --check-status -a $BINTRAY_USER:$BINTRAY_TOKEN POST  https://api.bintray.com/packages/$BINTRAY_USER/docker/$DOCKER_IMAGE/versions/$DOCKER_TAG/release_notes < release-content-template.json
   
   
}

if [ "$1" != "" ] && [ "$2" != "" ] && [ "$3" != "" ] && [ "$4" != "" ] && [ "$5" != "" ] && [ "$6" != "" ] && [ "$7" != "" ] && [ "$8" != "" ]; then
    BINTRAY_USER=$1
    BINTRAY_TOKEN=$2
    DOCKER_IMAGE=$3
    DOCKER_TAG=$4
    README_FILE=$5
    VERSION_RELEASE_NOTES=$6
    IMAGE_LABELS=$7
    VERSION_ATTRIBUTES=$8
else
    
    echo "USAGE\n binary-metadata.sh [BINTRAY_USER] [BINTRAY_TOKEN] [DOCKER_IMAGE] [DOCKER_TAG] [README_FILE] [VERSION_RELEASE_NOTES] [IMAGE_LABELS] [IMAGE_ATTRIBUTES]"
    echo "\t [BINTRAY_USER] - Your bintray user name"
    echo "\t [BINTRAY_TOKEN] - Your bintray api token"
    echo "\t [DOCKER_IMAGE] - Docker image name which will be updated"
    echo "\t [DOCKER_TAG] - Docker tag which will be updated"
    echo "\t [README_FILE] - path of readme file (markdown)"
    echo "\t [VERSION_RELEASE_NOTES] - Path of release notes (markdown)"
    echo "\t [IMAGE_LABELS] - Bintray labels"
    echo "\t [IMAGE_ATTRIBUTES] - Bintray attributes"
    exit 1;
fi

echo $BASH_VERSION

mainloop
