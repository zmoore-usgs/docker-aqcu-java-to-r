#!/bin/sh
set -e

if [ -n "${RSERVE_PWD_PATH}" ]; then
  RSERVE_USER=$(cat ${RSERVE_PWD_PATH} | awk '{print $1;}')
  RSERVE_PASSWORD=$(cat ${RSERVE_PWD_PATH} | awk '{print $2;}')
fi

java -Djava.security.egd=file:/dev/./urandom -DkeystorePassword=$KEYSTORE_PASSWORD -DrserveUser=$RSERVE_USER -DrservePassword=$RSERVE_PASSWORD -jar app.jar $@

exec env "$@"