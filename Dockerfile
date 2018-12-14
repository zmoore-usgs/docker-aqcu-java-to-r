FROM usgswma/wma-spring-boot-base:8-jre-slim

ARG artifact_version=0.0.3-SNAPSHOT
ENV serverPort=7500
ENV HEALTHY_RESPONSE_CONTAINS='{"status":"UP"}'

RUN ./pull-from-artifactory.sh aqcu-maven-centralized gov.usgs.aqcu aqcu-java-to-r ${artifact_version} app.jar

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -k "https://127.0.0.1:${serverPort}${serverContextPath}${HEALTH_CHECK_ENDPOINT}" | grep -q ${HEALTHY_RESPONSE_CONTAINS} || exit 1
