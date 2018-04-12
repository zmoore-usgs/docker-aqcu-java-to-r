FROM cidasdpdasartip.cr.usgs.gov:8447/aqcu/aqcu-base:latest

RUN set -x & \
  apk update && \
  apk upgrade && \
  apk add --no-cache curl && \
  apk --no-cache add openssl
  
# Pull Artifact
ARG repo_name=aqcu-maven-centralized
ARG artifact_id=aqcu-java-to-r
ARG artifact_version=LATEST

RUN ./pull-from-artifactory.sh ${repo_name} gov.usgs.aqcu ${artifact_id} ${artifact_version} app.jar

# Add Launch Script
ADD launch-app.sh launch-app.sh
RUN ["chmod", "+x", "launch-app.sh"]

#Default ENV Values
ENV serverPort=7500

ENV RSERVE_PWD_PATH=/Rserve.pwd

ENV HEALTHY_RESPONSE_CONTAINS='{"status":{"code":"UP","description":""}'