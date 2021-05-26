#######################################################################################################
# The build process is done in 2 parts to make the final image as slim as possible                    #
# build image (install_unpack) copies and unpacks the software distributio  packages                  #
# build image (pack) moves from install_unpack the files and defines workspace, entry-poit and others #
#######################################################################################################

##################################################################################################
# Here we use a "build" image for packing to make the final image as small as possible           #
##################################################################################################
FROM openjdk:8-jre as install_unpack

WORKDIR /opt/pentaho-installer/

#Arguments definition
ARG INSTALLATION_PATH=/opt/pentaho
ARG INSTALLER_PATH=/opt/pentaho-installer
## Arguments for regular Pentaho client install
ARG PENTAHO_INSTALLER_NAME=pdi-ee-client
ARG PENTAHO_VERSION=8.3.0.0
ARG PENTAHO_PACKAGE_DIST=371
ARG FILE_SOFTWARE=${PENTAHO_INSTALLER_NAME}-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}-dist.zip
ARG FILE_RELEASE_NAME=${PENTAHO_INSTALLER_NAME}-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}

## Arguments required if SP is applied
ARG SERVICE_PACK_VERSION=8.3.0.10
#ARG SERVICE_PACK_VERSION
ARG SERVICE_PACK_DIST=816
ARG SERVICE_PACK_FILENAME=PDIClient-SP-${SERVICE_PACK_VERSION}-${SERVICE_PACK_DIST}.bin

#Copy to temporary location the content of predownloaded folder
COPY ./predownloaded/* /opt/pentaho-installer/

##########################################
# Here comes the GA Install part
RUN if [ ! -f "/opt/pentaho-installer/$FILE_SOFTWARE" ]; \
        then \
        echo "File $FILE_SOFTWARE Not Found in predownloaded, please download and copy to predownloaded folder"; exit 2; \
        fi;

# UNZIP and INSNTALL the Pentaho Client 
RUN unzip ${FILE_SOFTWARE}; 
RUN java -DINSTALL_PATH=${INSTALLATION_PATH} -DEULA_ACCEPT=true -jar ./${FILE_RELEASE_NAME}/installer.jar -options-system; 

# If SP is required
RUN if [ ! -z "${SERVICE_PACK_VERSION}" ]; then \
        if [ ! -f "${INSTALLER_PATH}/${SERVICE_PACK_FILENAME}" ]; then \
            echo "SP file ${SERVICE_PACK_FILENAME} NOT found in predownloaded folder, please download required artifact and copy to predownloaded folder or not specify SERVICE_PACK if not required"; exit 2; \
        else \
            chmod 755 ${INSTALLER_PATH}/${SERVICE_PACK_FILENAME}; \
            ${INSTALLER_PATH}/${SERVICE_PACK_FILENAME} -i silent -DEULA_ACCEPT=true -DUSER_INSTALL_DIR=${INSTALLATION_PATH}/data-integration -DSILENT_LOG=${INSTALLER_PATH}/pentaho-servicepack-installer.log; \
            cat ${INSTALLER_PATH}/pentaho-servicepack-installer.log; \
        fi \
    else \
        echo "Standard installation, no SP defined"; \
    fi;

##########################################
# Copy External Resources
# This can be used to override or add new Libraries, JDBCs, Configuration, etc...

COPY ./resources/* ${INSTALLATION_PATH}/data-integration/

##################################################################################################
# Here is where we create the final image                                                        #
##################################################################################################
FROM openjdk:8u282-jdk as pack

# In case of Ubuntu we need to install a few things...
#FROM ubuntu:latest
#RUN apt-get update; \
#     apt-get install -y libwebkitgtk-1.0-0; \
#     apt-get install -y openjdk-8-jre;

#Arguments
ARG INSTALLATION_PATH=/opt/pentaho

# Create unprivileged user
ENV PENTAHO_UID=5000
ENV PENTAHO_USER=pentaho
ENV PENTAHO_HOME=/home/pentaho 
ENV PENTAHO_LICENSE_PATH=

# Create user for non-root account
RUN groupadd --gid ${PENTAHO_UID} ${PENTAHO_USER} \
    && useradd --home-dir ${PENTAHO_HOME} --create-home --uid ${PENTAHO_UID} \
    --gid ${PENTAHO_UID} --shell /bin/bash --skel /dev/null ${PENTAHO_USER}

#Default to Windows host, please override for other cases
#ENV DISPLAY=host.docker.internal:0

#This Setting is to skipe WEB TOOLKIT GTK Check. Since the use of this mack normally does no use GUI.
# If you want GUI, then istall libwebkitgtk-1.0-0 as the line commented above
ENV SKIP_WEBKITGTK_CHECK=1

COPY --from=install_unpack  ${INSTALLATION_PATH}/data-integration/ ${INSTALLATION_PATH}/data-integration/

#While this volume is for License, you can use "secrets" and point to /run/secrets/installedLicenses.xml.
VOLUME [ "${INSTALLATION_PATH}/pentahoLicense/"]

#Assign permissions to pentaho on /opt/pentaho
RUN chown -R pentaho:root ${INSTALLATION_PATH}

#Use data-integration installation dir as WORKDIR
WORKDIR ${INSTALLATION_PATH}/data-integration

#Setup JVM level parameters/variables
ENV PENTAHO_DI_JAVA_OPTIONS="-Dfile.encoding=utf8 -Dpentaho.installed.licenses.file=${INSTALLATION_PATH}/pentahoLicense/installedLicenses.xml -XX:+UseConcMarkSweepGC -XX:+ExplicitGCInvokesConcurrent -XX:+CMSClassUnloadingEnabled -XX:+AggressiveOpts" 
# WARNING carefull with the below options, REMOVED from default, 
#         because if the Container does not have memory limits, 
#         then it can use all the host memory.
# -XX:MinRAMPercentage=60.0 -XX:MaxRAMPercentage=90.0

#Use pentaho user
USER ${PENTAHO_USER}