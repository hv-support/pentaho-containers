# Pentaho Server Container

Target tag : pentaho/pentaho-server:<PENTAHO_VERSION>
PENTAHO_VERSION can be a GA release, entire patch version release or installation of particular SP. For SP installation, associeated .bin is required

In order to keep the size of the final image as small as possible, we want to download and unpack on a separated process.
For this reason we use multi stage docker build process.
* Stage 1 is to validate required packages are in place based on parameters/configuration selected and Uppack and Install the software
* Stage 2 is to create the final Image

## Stage 1 
Looks in the predownloaded folder the file "pentaho-server-ee-<PENTAHO_VERSION>-<PENTAHO_DIST>-dist.zip"
if the file exists, then it will use it to build the image,
If does not exists, then installation process stops showing error message with required packages to continue

## Stage 2
Copies from Stage 1 the installed software, prepares the Volumnes and setup ENV settings

**Important**: As part of container execution, entry point is defined to copy all the content located inside of entrypoint/docker-entrypoint-init. This have the same folder structure of petaho-server. This is the right parh to attach specific configuration to the server (security, internal databases, repository, additional plugins, etc). You can replace this static content using Volumes

## Building the package
recommended command 

```bash

docker build -t pentaho/pentaho-server:9.1.0.0 $(for i in `cat settings.env`; do out+="--build-arg $i " ; done; echo $out;out="") .

```



