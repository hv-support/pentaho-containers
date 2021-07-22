# Kubernetes deployment
Set of manifests (Kubernetes YAML files) and guidelines to deploy Pentaho containers using Kubernetes framework

It contains working examples using containers previously register in corresponding container registry (as example GCR: Google Container Registry).

- Under manifest folder. YAML files related with Pentaho Data Integration Kubernetes deployment. Either as a JOB or as a Deployment (Single Pod also possible)
- Under pentaho-server. YAML files related with Pentaho Server deployment using different internal databases (MSSQL, PostgreSQL, etc) either using persistence or not.
- Under jenkins-pipeline. Some examples to include your Pentaho manifests as part of DevOps pipeline with Jenkins

