#!/bin/sh
set -e

if [ -z "${KEYSTORE_PASSWORD_FILE}" ] || [ ! -f ${KEYSTORE_PASSWORD_FILE} ]; then
  KEYSTORE_PASSWORD="changeme"
else
  KEYSTORE_PASSWORD=`cat $KEYSTORE_PASSWORD_FILE`
fi

if [ -n "${TOMCAT_CERT_PATH}" ]; then
  openssl pkcs12 -export -in $TOMCAT_CERT_PATH -inkey $TOMCAT_KEY_PATH -name $keystoreSSLKey -out tomcat.p12 -password pass:$KEYSTORE_PASSWORD
  keytool -v -importkeystore -deststorepass $KEYSTORE_PASSWORD -destkeystore $keystoreLocation -deststoretype PKCS12 -srckeystore tomcat.p12 -srcstorepass $KEYSTORE_PASSWORD -srcstoretype PKCS12 -noprompt
fi

if [ -d "${CERT_IMPORT_DIRECTORY}" ]; then
  for c in $CERT_IMPORT_DIRECTORY/*.crt; do
    FILENAME="${c}"
    echo "Importing ${FILENAME}"
    keytool -importcert -noprompt -trustcacerts -file $FILENAME -alias $FILENAME -keystore /etc/ssl/certs/java/cacerts -storepass changeit -noprompt;
  done
fi

java -Djava.security.egd=file:/dev/./urandom -DkeystorePassword=$KEYSTORE_PASSWORD -DrserveServicePassword=$(cat ${RSERVE_SERVICE_PASSWORD_PATH}) -jar app.jar $@

exec env "$@"