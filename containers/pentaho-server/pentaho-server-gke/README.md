# Pentaho Server Container

Target tag : pentaho/pentaho-server-gke:<PENTAHO_VERSION>

* Expected mandatory argument

**ARG PENTAHO_SERVER_BASE_TAG**. It represent the version of the base image to be used.

Specific layer for Pentaho server (no matter what version) to have it ready to interact with GCP environment

For example: 
- Include Google Cloud SDK
- Activate specific Google credentials to interact with
- Get configuration or artifacts present in GCS bucket

### Building the image
recommended command 

```bash

build -f ./Dockerfile --build-arg "PENTAHO_SERVER_BASE_TAG=9.1.0.0" -t pentaho/pentaho-server-gke:9.1.0.0 .

```



