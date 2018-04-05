FROM openjdk:8-jdk-alpine

RUN set -x & \
  apk update && \
  apk upgrade && \
  apk add --no-cache curl && \
  apk --no-cache add openssl
  
ARG repo_name=aqcu-maven-centralized
ARG artifact_id=aqcu-java-to-r
ARG artifact_version=LATEST

ADD pull-from-artifactory.sh pull-from-artifactory.sh
RUN ["chmod", "+x", "pull-from-artifactory.sh"]

RUN ./pull-from-artifactory.sh ${repo_name} gov.usgs.aqcu ${artifact_id} ${artifact_version} app.jar

ADD entrypoint.sh entrypoint.sh
RUN ["chmod", "+x", "entrypoint.sh"]

#Default ENV Values
ENV requireSsl=true
ENV serverPort=443
ENV serverContextPath=/
ENV springFrameworkLogLevel=info
ENV keystoreLocation=/localkeystore.p12
ENV keystorePassword=changeme
ENV keystoreSSLKey=tomcat

ENV ribbonMaxAutoRetries=3
ENV ribbonConnectTimeout=1000
ENV ribbonReadTimeout=10000
ENV hystrixThreadTimeout=10000000
ENV RSERVE_SERVICE_PASSWORD_PATH=/rservePassword.txt
ENV TOMCAT_CERT_PATH=/tomcat-wildcard-ssl.crt
ENV TOMCAT_KEY_PATH=/tomcat-wildcard-ssl.key

ENTRYPOINT [ "/entrypoint.sh" ]

HEALTHCHECK CMD curl -k "https://127.0.0.1:${serverPort}${serverContextPath}/health" | grep -q '{"status":"UP"}' || exit 1