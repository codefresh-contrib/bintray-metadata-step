FROM alpine/httpie:3.5-0.9.9

RUN apk add --no-cache bash sed grep bc coreutils

RUN mkdir /app

COPY bintray-edit-metadata.sh file-content-template.json release-content-template.json /app/

RUN chmod +x /app/bintray-edit-metadata.sh

ENTRYPOINT []

CMD /app/bintray-edit-metadata.sh $BINTRAY_USER $BINTRAY_TOKEN $DOCKER_IMAGE $DOCKER_TAG $README_FILE $VERSION_RELEASE_NOTES $IMAGE_LABELS $VERSION_ATTRIBUTES