#!/bin/sh
set -e
CURL_OPTS="--retry 5 --max-time 300 --connect-timeout 10 -fSL"
curl -s $CURL_OPTS https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 -o /tmp/get-helm.sh
chmod +x /tmp/get-helm.sh
/tmp/get-helm.sh

