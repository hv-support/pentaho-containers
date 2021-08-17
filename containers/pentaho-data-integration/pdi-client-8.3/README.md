# Pentaho Data Integration Client Container
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

Target tag (For example 8.3): pentaho/pdi-client:X.0.0 -> pentaho/pdi-client:8.3.0.0 
With Service Pack (Z): pentaho/pdi-client:8.3.0.Z

In order to keep the size of the final image as small as possible, we want to download and unpack on a separated process.
For this reason we use multi stage docker build process.
* Stage 1 is to get the Package to be installed and Unpack and Install the software
* Stage 2 is to create the final Image

## Stage 1 
Looks in the predownloaded folder the file "pdi-ee-client-8.3.0.0-371-dist.zip"
if the file exists, then it will use it to build the image

## Stage 2
Copies from Stage 1 the installed software and prepares the Volumes, ENV settings 

# Building the package
recommended command 

Build GA Version

```bash
docker build -t pentaho/pdi-client:8.3.0.0 .
```

Build with Service Pack. Example using 8.3 SP 12

```bash
docker build -f ./Dockerfile --build-arg SERVICE_PACK_VERSION=8.3.0.22 --build-arg SERVICE_PACK_DIST=1241 -t pentaho/pentaho-server:8.3.0.22 .
```

# Usage of resultant image

```bash
docker run -it "pentaho/pdi-client:8.3.0.0" bash
```

