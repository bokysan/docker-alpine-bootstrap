#!/bin/sh
set -e
CURL_OPTS="-s --retry 5 --max-time 300 --connect-timeout 10 -fSL"
KUBECTL_VERSION=$(curl $CURL_OPTS https://dl.k8s.io/release/stable.txt)
ARCH="$(uname -m)"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
if test "${ARCH}" == "aarch64"; then 
    ARCH="arm64"
elif test "${ARCH}" == "x86_64"; then 
    ARCH="amd64"
fi
URL="https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${OS}/${ARCH}/kubectl"
echo "$URL"
curl $CURL_OPTS -o /tmp/kubectl "${URL}"
chmod +x /tmp/kubectl
mv /tmp/kubectl /usr/local/bin/kubectl

