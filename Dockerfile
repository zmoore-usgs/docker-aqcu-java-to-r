FROM cidasdpdasartip.cr.usgs.gov:8447/wma/wma-spring-boot-base:0.0.1

# Pull Artifact
ARG repo_name=aqcu-maven-centralized
ARG artifact_id=aqcu-java-to-r
ARG artifact_version=0.0.2-SNAPSHOT
RUN ./pull-from-artifactory.sh ${repo_name} gov.usgs.aqcu ${artifact_id} ${artifact_version} app.jar

# Add Launch Script
ADD launch-app.sh launch-app.sh
RUN ["chmod", "+x", "launch-app.sh"]

#Default ENV Values
ENV serverPort=7500
ENV maxHeapSpace=300M

ENV RSERVE_PWD_PATH=/Rserve.pwd

ENV HEALTHY_RESPONSE_CONTAINS='{"status":"UP"}'
