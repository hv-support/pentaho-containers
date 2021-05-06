# Pentaho Client Container

Target tag : pentaho/pdi-client:8.3.0.0

In order to keep the size of the final image as small as possible, we want to download and unpack on a separated process.
For this reason we use multi stage docker build process.
* Stage 1 is to get the Package to be installed and Uppack and Install the software
* Stage 2 is to create the final Image

## Stage 1 
Looks in the predownloaded folder the file "pdi-ee-client-8.3.0.0-371-dist.zip"
if the file exists, then it will use it to build the image,
If does not exists, then it will try to download from FTP given the FTP details in the settings.env

## Stage 2
Copies from Stage 1 the installed software and prepares the Volumnes, ENV settings 

## Building the package
recommended command 

```bash

docker build -t pentaho/pdi-client:8.3.0.0 $(for i in `cat ftp_settings.env`; do out+="--build-arg $i " ; done; echo $out;out="") .

```



