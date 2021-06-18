#!/bin/sh

gcloud auth activate-service-account --key-file=$CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE

mkdir ~/tmp/
gsutil cp -r $GCS_PENTAHO_CONFIG_PATH/* ~/tmp/

cp -r ~/tmp/* $PENTAHO_INSTALLATION_PATH

exec "$@"