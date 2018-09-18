FROM alpine:edge
LABEL maintainer="Bojan Cekrlic - https://github.com/bokysan/docker-alpine-bootstrap/"

# See README.md for details
ENV KUBE_LATEST_VERSION="v1.3.5"


# Install basic set of tools
RUN   \
      apk add --no-cache --upgrade && \
      apk add --no-cache --update bash curl wget unzip tar xz sed gawk vim postgresql-client libressl && \
      curl --retry 5 --max-time 300 --connect-timeout 10 -fsSL https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
      (rm "/tmp/"* 2>/dev/null || true) && (rm -rf /var/cache/apk/* 2>/dev/null || true)

# Install wait-for-service
COPY  files/* /usr/local/bin/

