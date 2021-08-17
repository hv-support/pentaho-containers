#Argument to define what version of Pentaho server should be used
#Important: this is only available if you are using Docker version at least 18.09.8, build bfed4f5
ARG PENTAHO_CLIENT_BASE_TAG=latest

# Starting point based on pdi-client base image either GA or with SP applied. 
# Adapt version accordingly based on your previous build command for it 
FROM pentaho/pdi-client:${PENTAHO_CLIENT_BASE_TAG}

## Install required packages to work in GCP, mainly GCP SDK
RUN apt-get install curl unzip -y; \
    curl -k -sSL https://sdk.cloud.google.com > /tmp/gcl && bash /tmp/gcl --install-dir=~/gcloud --disable-prompts

ENV PATH $PATH:/root/gcloud/google-cloud-sdk/bin

COPY "./entrypoint/" /

COPY "./resources/" /resources/

ENTRYPOINT ["/docker-entrypoint.sh"] 

# docker run --rm -it -v "/mnt/c/Development/pentaho-support-team-a26275d9d49e.json":/secrets/key.json -v /mnt/c/Development/support_containers/support_containers/local/installedLicenses.xml:/secrets/pentahoLicense -e CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=/secrets/key.json -e CLOUDSDK_CORE_PROJECT=pentaho-support-team  -e GCOUD_PENTAHO_PROJECT_PATH=gs://support-emea-hv/demo-db/export_1e6d8e59-fdac-11ea-bf99-8b5cbf5b8621.zip -e PENTAHO_INSTALLED_LICENSE_PATH=/secrets/pentahoLicense "pentaho/pdi-client:8.3.0.0-gcp" bash