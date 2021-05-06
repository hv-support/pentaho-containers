#!/bin/sh

gcloud auth activate-service-account --key-file=$CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE

export PENTAHO_PROJECT_PATH=/opt/pentaho/project/
export KETTLE_HOME=$PENTAHO_PROJECT_PATH
#export CURRENT_HOSTNAME=$(hostname -i)
#echo "-------------------------------------------------------------------------------------------------"
#echo $CURRENT_HOSTNAME

cp -r /resources/* /opt/pentaho/data-integration/

mkdir $PENTAHO_PROJECT_PATH
gsutil cp $GCOUD_PENTAHO_PROJECT_PATH $PENTAHO_PROJECT_PATH
unzip -d $PENTAHO_PROJECT_PATH $PENTAHO_PROJECT_PATH*

#exec "$@"
#./carte.sh $CURRENT_HOSTNAME 8080
./carte.sh pwd/carte-config.xml