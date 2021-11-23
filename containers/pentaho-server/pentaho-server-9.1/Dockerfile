FROM openjdk:8-jre as install_unpack

WORKDIR /opt/pentaho-installer/

#Arguments definition
ARG INSTALLATION_PATH=/opt/pentaho
ARG INSTALLER_PATH=/opt/pentaho-installer
## Arguments for regular Pentaho Server install
ARG PENTAHO_INSTALLER_NAME=pentaho-server-ee
ARG PENTAHO_VERSION=9.1.0.0
ARG PENTAHO_PACKAGE_DIST=324
ARG FILE_SOFTWARE=${PENTAHO_INSTALLER_NAME}-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}-dist.zip
ARG FILE_RELEASE_NAME=${PENTAHO_INSTALLER_NAME}-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}
## Arguments related to Pentaho Server plugins
ARG FILE_PAZ=paz-plugin-ee-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}-dist.zip
ARG FILE_PIR=pir-plugin-ee-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}-dist.zip
ARG FILE_PDD=pdd-plugin-ee-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}-dist.zip

## Arguments required if SP is applied
ARG SERVICE_PACK_VERSION=9.1.0.7
#ARG SERVICE_PACK_VERSION
ARG SERVICE_PACK_DIST=567
ARG SERVICE_PACK_FILENAME=PentahoServer-SP-${SERVICE_PACK_VERSION}-${SERVICE_PACK_DIST}.bin

#Copy from local predownloaded folder al the artifacts required for Pentaho installation
COPY ./predownloaded/* ${INSTALLER_PATH}

##########################################
# Here comes the GA Install part
##########################################
#
# First, It validates if main software package (version release) is available or stop the process asking for file if not there
RUN if [ ! -f "${INSTALLER_PATH}/${FILE_SOFTWARE}" ]; \
        then \
        echo "File ${FILE_SOFTWARE} Not Found in predownloaded folder, please download required artifact and copy to predownloaded folder"; exit 2; \
    fi;

# UNZIP and INSTALL the Pentaho server 
RUN unzip ${FILE_SOFTWARE}; 
RUN java -DINSTALL_PATH=${INSTALLATION_PATH} -DEULA_ACCEPT=true -jar ./${FILE_RELEASE_NAME}/installer.jar -options-system; 

# UNZIP and INSTALL plugins
RUN if [ -f "${FILE_PAZ}" ]; \
    then \
        unzip ${FILE_PAZ}; \
        java -DINSTALL_PATH=${INSTALLATION_PATH}/pentaho-server/pentaho-solutions/system/ -DEULA_ACCEPT=true -jar ./paz-plugin-ee-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}/installer.jar -options-system; \
    fi;

RUN if [ -f "${FILE_PIR}" ]; \
    then \
        unzip ${FILE_PIR}; \
        java -DINSTALL_PATH=${INSTALLATION_PATH}/pentaho-server/pentaho-solutions/system/ -DEULA_ACCEPT=true -jar ./pir-plugin-ee-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}/installer.jar -options-system; \
    fi;

RUN if [ -f "${FILE_PDD}" ]; \
    then \
        unzip ${FILE_PDD}; \
        java -DINSTALL_PATH=${INSTALLATION_PATH}/pentaho-server/pentaho-solutions/system/ -DEULA_ACCEPT=true -jar ./pdd-plugin-ee-${PENTAHO_VERSION}-${PENTAHO_PACKAGE_DIST}/installer.jar -options-system; \
    fi;


# If SP is required
RUN if [ ! -z "${SERVICE_PACK_VERSION}" ]; then \
        if [ ! -f "${INSTALLER_PATH}/${SERVICE_PACK_FILENAME}" ]; then \
            echo "SP file ${SERVICE_PACK_FILENAME} NOT found in predownloaded folder, please download required artifact and copy to predownloaded folder or not specify SERVICE_PACK if not required"; exit 2; \
        else \
            chmod 755 ${INSTALLER_PATH}/${SERVICE_PACK_FILENAME}; \
            ${INSTALLER_PATH}/${SERVICE_PACK_FILENAME} -i silent -DEULA_ACCEPT=true -DUSER_INSTALL_DIR=${INSTALLATION_PATH}/pentaho-server -DSILENT_LOG=${INSTALLER_PATH}/pentaho-servicepack-installer.log; \
            cat ${INSTALLER_PATH}/pentaho-servicepack-installer.log; \
        fi \
    else \
        echo "Standard installation, no SP defined"; \
    fi;
########################################################################################################################
# 
# Since this image is for the GA release, no service pack in this build.
FROM openjdk:8u282-jdk as pack

#FROM ubuntu:latest
#RUN apt-get update; \
#     apt-get install -y libwebkitgtk-1.0-0; \
#     apt-get install -y openjdk-8-jre;

RUN apt update; apt install -y libxtst6 libxi6 libxrender1

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

# Use installed software from installation base and assign non-elevated-privileges user in destination path
COPY --from=install_unpack --chown=${PENTAHO_USER}:${PENTAHO_USER} ${INSTALLATION_PATH}/pentaho-server/ ${INSTALLATION_PATH}/pentaho-server/

#COPY --chown=${PENTAHO_USER}:${PENTAHO_USER} ./entrypoint/ /

COPY ./entrypoint/ /

#Use pentaho user
#USER ${PENTAHO_USER}

WORKDIR ${INSTALLATION_PATH}/pentaho-server

ENTRYPOINT ["/docker-entrypoint.sh"] 

EXPOSE 8080

CMD [ "sh", "./tomcat/bin/catalina.sh", "run" ]


