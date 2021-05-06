FROM openjdk:8-jre as unpack


COPY ./predownloaded/ /opt/pentaho/tray_zip/

RUN apt update; \
    apt install dos2unix; \
    cd /opt/pentaho/tray_zip/; \
    unzip /opt/pentaho/tray_zip/carte*; \
    dos2unix /opt/pentaho/tray_zip/carte-clustering-server/bin/*


FROM openjdk:8-jre

COPY --from=unpack /opt/pentaho/tray_zip/carte-clustering-server/ /opt/pentaho/tray/

# Create unprivileged user
ENV PENTAHO_UID="1000"
ENV PENTAHO_HOME=/home/pentaho 
RUN useradd -u "${PENTAHO_UID:?}" -g 0 -s "$(command -v bash)" -md "${PENTAHO_HOME:?}" pentaho

WORKDIR /opt/pentaho/tray/

VOLUME [ "/opt/pentaho/es-license-key.txt"]
ENV PENTAHO_ES_LICENSE_FILE=/run/secrets/es-license-key.txt

#Assign permissions to pentaho on /opt/pentaho
RUN chown -R pentaho:root /opt/pentaho

EXPOSE 9115

#Drop root privileges
USER 1000:0

CMD [ "./bin/tray.sh" ]