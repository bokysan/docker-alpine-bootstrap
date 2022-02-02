#!/bin/sh
set -e
cd /tmp
CURL_OPTS="--retry 5 --max-time 300 --connect-timeout 10 -fSL"
curl -s $CURL_OPTS https://github.com/bokysan/wait-for-service/archive/refs/heads/master.tar.gz | tar xz
mv /tmp/wait-for-service-*/wait-for-service /usr/local/bin
mv /tmp/wait-for-service-*/fabric8-* /usr/local/bin

