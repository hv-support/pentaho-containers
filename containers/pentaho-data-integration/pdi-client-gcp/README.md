# Pentaho Data Integration Client Container for Google Cloud Platform interaction
Here you can find the build process to containerize Pentaho Data Integration Client tool.

This image can be used for
* Carte Instances
* Kitchen / Pan processes
* Kubernetes Deployment
* Cloud Deployment 
  * AWS
  * Google Cloud
  * ...

# Overview

This container image template is based on pdi-client-XX image. Argument is required to specify what specific version or LATEST will be used

Its main purpose is to show how to adapt standard pdi-client image to interact with Google Cloud platform resources such as Google Cloud Storage (GCS) buckets

Additionally, it incorporate certain customization elements in order to adapt basic image configuration and entry point.

## resources folder
Used to incorporate customization to default data-integration directory installed in the base image. You can incorporate configuration, enable/disable plugins, drivers, etc. using this approach

## entrypoint folder
Adapt image entry point to execute certain commands at execution time. In this template, entrypoint is configured to download ETL artifacts from GCS place it in a PROJECT folder and execute/expose carte service using custom configuration placed as part of prviously described "resources" folder

# Building the package
recommended command 

Build without specifying base image version (it use latest TAG):

```bash
docker build -f ./Dockerfile -t pentaho/ pentaho/pdi-client-gcp:8.3.0.0 .
```

Build specifying base image to be used: 

```bash
docker build -f ./Dockerfile --build-arg "PENTAHO_CLIENT_BASE_TAG=8.3.0.0" -t pentaho/pdi-client-gcp:8.3.0.0 .
```

# Usage of resultant image

```bash
docker run -it "pentaho/pdi-client-gcp:8.3.0.0" bash
```

