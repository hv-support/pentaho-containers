# Pentaho Server Container

Target tag : pentaho/pentaho-server:<PENTAHO_VERSION>
PENTAHO_VERSION can be a GA release, entire patch version release or installation of particular SP. For SP installation, associeated .bin is required

## Arguments at build time (with default values):

- **Base arguments definition**

INSTALLATION_PATH=/opt/pentaho

INSTALLER_PATH=/opt/pentaho-installer

- Arguments for regular Pentaho Server install

PENTAHO_INSTALLER_NAME=pentaho-server-ee

PENTAHO_VERSION=8.3.0.0

PENTAHO_PACKAGE_DIST=371

FILE_SOFTWARE=${PENTAHO_INSTALLER_NAME}-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}-dist.zip

FILE_RELEASE_NAME=${PENTAHO_INSTALLER_NAME}-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}

- Arguments related to Pentaho Server plugins

FILE_PAZ=paz-plugin-ee-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}-dist.zip

FILE_PIR=pir-plugin-ee-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}-dist.zip

FILE_PDD=pdd-plugin-ee-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}-dist.zip

- Arguments required if SP is applied

SERVICE_PACK_VERSION=

SERVICE_PACK_DIST=

SERVICE_PACK_FILENAME=PentahoServer-SP-${SERVICE_PACK_VERSION}-${SERVICE_PACK_DIST}.bin

## Stages
In order to keep the size of the final image as small as possible, we want to download and unpack on a separated process.
For this reason we use multi stage docker build process.
* Stage 1 is to validate required packages are in place based on parameters/configuration selected and Uppack and Install the software
* Stage 2 is to create the final Image

### Stage 1 
Looks in the predownloaded folder the file "${FILE_SOFTWARE} (${PENTAHO_INSTALLER_NAME}-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}-dist.zip)"

If the file exists, then it will use it to build the image,

If does not exists, then installation process stops showing error message with required packages to continue

Addionally to base package, process includes Pentaho plugins (PAZ, PIR, PDD, etc) based in predownload folder content

As an optional step, Service Pack can be especified as parameter and a check is performed to guarantee that specified version has its corresponding SP artigact available in predownloaded folder

### Stage 2
Copies from Stage 1 the installed software, prepares the Volumnes and setup ENV settings

**Important**: As part of container execution, entry point is defined to copy all the content located inside of entrypoint/docker-entrypoint-init. This have the same folder structure of petaho-server. This is the right parh to attach specific configuration to the server (security, internal databases, repository, additional plugins, etc). You can replace this static content using Volumes

### Building the package
recommended command 

#### Without Service Pack
```bash

docker build -f ./Dockerfile -t pentaho/pentaho-server:9.1.0.0 .

```

#### With Service Pack
```bash

docker build -f ./Dockerfile --build-arg SERVICE_PACK_VERSION=9.1.0.7 --build-arg SERVICE_PACK_DIST=1241 -t pentaho/pentaho-server:9.1.0.7 .

```



