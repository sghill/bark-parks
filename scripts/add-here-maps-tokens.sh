#!/bin/sh
set -e

if [ $# -ne 3 ]; then
  echo "Usage: $0 HERE_MAPS_APP_ID HERE_MAPS_AUTH_TOKEN AUTHORIZE_FILE"
  exit 1
fi

sed -i "s/%APPID%/$1/g" $3
sed -i "s/%AUTHENTICATIONTOKEN%/$2/g" $3

