pipeline {
    agent none
    stages {
        stage('Initialiation') {
            matrix {
                agent {
                    kubernetes {
                        defaultContainer 'pentaho-server'
                        yaml """
apiVersion: v1
kind: Pod
metadata:
  name: pentaho-server
spec:
  volumes:
  - name: key
    secret:
      secretName: key
  - name: pentaho-license
    secret:
      secretName: pentaho-license
  - name: init-databases-volume
    configMap:
      name: init-db-scripts
  containers:
  - name: postgres
    image: postgres:${POSTGRES_VERSION}
    imagePullPolicy: 'Always'
    ports:
      - containerPort: 5432
    env:
      - name: POSTGRES_PASSWORD
        value: password
      - name: PGDATA
        value: /var/lib/postgresql/data/pgdata
    ports:
      - containerPort: 5432
        name: postgresql
        protocol: TCP
    resources:
      requests:
        memory: '1500Mi'
        cpu: '1'
    volumeMounts:
      - name: init-databases-volume
        mountPath: /docker-entrypoint-initdb.d
  - name: pentaho-server
    image: gcr.io/pentaho-support-team/pentaho/pentaho-server-gke:${PENTAHO_VERSION}
    imagePullPolicy: 'Always'
    resources:
      limits:
        memory: '3500Mi'
    requests:
        memory: '2000Mi'
        cpu: '2'
    ports:
      - containerPort: 8080
    volumeMounts:
      - name: key
        mountPath: '/secrets/key'
      - name: pentaho-license
        mountPath: '/secrets/pentahoLicense'
    env:
      - name: GCS_PENTAHO_CONFIG_PATH
        value: 'gs://support-emea-hv/pentaho-gke/psql12-config'
      - name: PENTAHO_INSTALLATION_PATH
        value: '/opt/pentaho/pentaho-server'
      - name: CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE
        value: '/secrets/key/key.json'
      - name: GOOGLE_APPLICATION_CREDENTIALS
        value: '/secrets/key/key.json'
      - name: PENTAHO_INSTALLED_LICENSE_PATH
        value: '/secrets/pentahoLicense/.installedLicenses.xml'
      - name: CATALINA_OPTS
        value: '-Dpentaho.installed.licenses.file=/secrets/pentahoLicense/.installedLicenses.xml -XX:+UnlockExperimentalVMOptions -XX:+UseContainerSupport -XX:+UseCGroupMemoryLimitForHeap -Dfile.encoding=utf8 -XX:MaxRAMPercentage=80.0 -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -XX:+ExitOnOutOfMemoryError -XX:+UseG1GC'                
    args: ['/opt/pentaho/pentaho-server/tomcat/bin/catalina.sh','run']
                            """
                    }
                }
                axes {
                    axis {
                        name 'POSTGRES_VERSION'
                        values '9.6', '10.17', '11.12','13.3'
                    }
                    axis {
                        name 'PENTAHO_VERSION'
                        values '8.3.0.0','8.3.0.22', '9.1.0.7'
                    }
                }
                stages {
                    stage('Server Started') {
                        steps {
                            echo "Working with Postgres:${POSTGRES_VERSION} and Pentaho:${PENTAHO_VERSION}"
                            sleep 10
                            sh "curl 'http://localhost:8080/pentaho/api/repo/files/%3A/tree?depth=-1&showHidden=false&filter=*%7CFOLDERS&_=1621522639682' -H 'Authorization: Basic YWRtaW46cGFzc3dvcmQ=' --max-time 240"
                        }
                    }
                    stage('Test API') {
                        steps {
                            echo "Working with Postgres:${POSTGRES_VERSION} and Pentaho:${PENTAHO_VERSION}"
                            sh "curl 'http://localhost:8080/pentaho/api/repo/files/%3A/tree?depth=-1&showHidden=false&filter=*%7CFOLDERS&_=1621522639682' -H 'Authorization: Basic YWRtaW46cGFzc3dvcmQ=' --max-time 240"
                        }
                    }
                    stage('OpsMart Test') {
                        steps {
                            echo "Working with Postgres:${POSTGRES_VERSION} and Pentaho:${PENTAHO_VERSION}"
                            sh "curl 'http://localhost:8080/pentaho/api/repo/files/%3A/tree?depth=-1&showHidden=false&filter=*%7CFOLDERS&_=1621522639682' -H 'Authorization: Basic YWRtaW46cGFzc3dvcmQ=' --max-time 240"
                        }
                    }
                    stage('Use as Source and Target') {
                        steps {
                            echo "Working with Postgres:${POSTGRES_VERSION} and Pentaho:${PENTAHO_VERSION}"
                            sh "curl 'http://localhost:8080/pentaho/api/repo/files/%3A/tree?depth=-1&showHidden=false&filter=*%7CFOLDERS&_=1621522639682' -H 'Authorization: Basic YWRtaW46cGFzc3dvcmQ=' --max-time 240"
                        }
                    }
                }
            }
        }
    }
}
