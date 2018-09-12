FROM alpine/httpie:3.5-0.9.9

RUN mkdir /app

COPY bintray-edit-metadata.sh /app

RUN chmod +x /app/bintray-edit-metadata.sh

CMD /app/bintray-edit-metadata.sh $SERVICE_NAME $DEPLOYMENT_NAME $NEW_VERSION true $HEALTH_SECONDS $NAMESPACE