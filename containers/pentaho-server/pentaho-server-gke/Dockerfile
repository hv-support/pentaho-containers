#Argument to define what version of Pentaho server should be used
#Important: this is only available if you are using Docker version at least 18.09.8, build bfed4f5
ARG PENTAHO_SERVER_BASE_TAG=latest

# Starting point based on pentaho-server base image either GA or with SP applied. 
# Adapt version using PENTAHO_SERVER_BASE_TAR argument. If not present, it will try to ue latest
FROM pentaho/pentaho-server:${PENTAHO_SERVER_BASE_TAG}

#run as non-elavated user. Assuming base image pentaho/pentaho-server:${PENTAHO_SERVER_BASE_TAG} was built with "pentaho" as user
# change it accordingly if base image was created with another user
#USER pentaho

## Install required packages to work in GCP, mainly GCP SDK
RUN apt-get install curl unzip python -y; \
    curl -k -sSL https://sdk.cloud.google.com > /tmp/gcl && bash /tmp/gcl --install-dir=~/gcloud --disable-prompts

ENV PATH $PATH:/root/gcloud/google-cloud-sdk/bin

COPY "./entrypoint/" /

ENTRYPOINT ["/docker-entrypoint.sh"] 

# docker run --rm -it -v "/mnt/c/Development/pentaho-support-team-a26275d9d49e.json":/secrets/key.json -v /mnt/c/Development/support_containers/support_containers/local/installedLicenses.xml:/secrets/pentahoLicense -e CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=/secrets/key.json -e CLOUDSDK_CORE_PROJECT=pentaho-support-team  -e GCOUD_PENTAHO_PROJECT_PATH=gs://support-emea-hv/demo-db/export_1e6d8e59-fdac-11ea-bf99-8b5cbf5b8621.zip -e PENTAHO_INSTALLED_LICENSE_PATH=/secrets/pentahoLicense "pentaho/pdi-client:8.3.0.0-gcp" bash