FROM openjdk:8-jre as install_unpack

WORKDIR /opt/pentaho-installer/

#Arguments definition
ARG FILE_SOFTWARE=pentaho-server-ee-9.1.0.0-324-dist.zip
ARG FILE_RELEASE_NAME=pentaho-server-ee-9.1.0.0-324
ARG INSTALLATION_PATH=/opt/pentaho

#Copy from local predownloaded folder al the artifacts required for Pentaho installation
COPY ./predownloaded/* /opt/pentaho-installer/

##########################################
# Here comes the GA Install part
RUN if [ ! -f "/opt/pentaho-installer/$FILE_SOFTWARE" ]; \
        then \
        echo "File $FILE_SOFTWARE Not Found in predownloaded, please download required artifact and copy to predownloaded folder"; exit 2; \
        fi;

# UNZIP and INSNTALL the Pentaho server 
RUN unzip ${FILE_SOFTWARE}; 
RUN java -DINSTALL_PATH=${INSTALLATION_PATH} -DEULA_ACCEPT=true -jar ./${FILE_RELEASE_NAME}/installer.jar -options-system; 
    

########################################################################################################################
# 
# Since this image is for the GA release, no service pack in this build.
FROM openjdk:8u282-jdk as pack

#FROM ubuntu:latest
#RUN apt-get update; \
#     apt-get install -y libwebkitgtk-1.0-0; \
#     apt-get install -y openjdk-8-jre;

ARG INSTALLATION_PATH=/opt/pentaho

# Create unprivileged user
ENV PENTAHO_UID=5000
ENV PENTAHO_USER=pentaho
ENV PENTAHO_HOME=/home/pentaho 
RUN groupadd --gid ${PENTAHO_UID} ${PENTAHO_USER} \
    && useradd --home-dir ${PENTAHO_HOME} --create-home --uid ${PENTAHO_UID} \
    --gid ${PENTAHO_UID} --shell /bin/bash --skel /dev/null ${PENTAHO_USER}

#Default to Windows host, please override for other cases
ENV DISPLAY=host.docker.internal:0

#This Setting is to skipe WEB TOOLKIT GTK Check. Since the use of this mack normally does no use GUI.
# If you want GUI, then istall libwebkitgtk-1.0-0 as the line commented above
ENV SKIP_WEBKITGTK_CHECK=1


COPY --from=install_unpack  ${INSTALLATION_PATH}/pentaho-server/ ${INSTALLATION_PATH}/pentaho-server/

WORKDIR ${INSTALLATION_PATH}/pentaho-server

#While this volume is for License, you can use "secrets" and point to /run/secrets/installedLicenses.xml.
VOLUME [ "${INSTALLATION_PATH}/pentahoLicense/"]

#Assign permissions to pentaho on /opt/pentaho
RUN chown -R ${PENTAHO_USER} ${INSTALLATION_PATH}

#Use pentaho user
USER ${PENTAHO_USER}

ENV PENTAHO_DI_JAVA_OPTIONS="-Dfile.encoding=utf8 -Dpentaho.installed.licenses.file=/opt/pentaho/pentahoLicense/installedLicenses.xml -XX:+UseConcMarkSweepGC -XX:+ExplicitGCInvokesConcurrent -XX:+CMSClassUnloadingEnabled -XX:+AggressiveOpts" 
# WARNING carefull with the below options, REMOVED from default, because if the Container does not have memory limits, then it can use all the host memory.
# -XX:MinRAMPercentage=60.0 -XX:MaxRAMPercentage=90.0


