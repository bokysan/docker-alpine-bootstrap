# ≡≡≡≡≡≡≡≡≡≡≡≡ Prepare downlaod ≡≡≡≡≡≡≡≡≡≡≡≡
FROM alpine:latest AS downloader
RUN apk update
RUN apk add bash curl jq

# ≡≡≡≡≡≡≡≡≡≡≡≡ Download kubectl ≡≡≡≡≡≡≡≡≡≡≡≡
FROM downloader AS kubectl
COPY scripts/download-kubectl.sh /
RUN sh /download-kubectl.sh

# ≡≡≡≡≡≡≡≡≡≡≡≡ Download helm ≡≡≡≡≡≡≡≡≡≡≡≡
FROM downloader AS helm
RUN apk add openssl
COPY scripts/download-helm.sh /
RUN sh /download-helm.sh

# ≡≡≡≡≡≡≡≡≡≡≡≡ Download wait-for-service ≡≡≡≡≡≡≡≡≡≡≡≡
FROM downloader AS wait-for-service
COPY scripts/download-wait-for-service.sh /
RUN sh /download-wait-for-service.sh

FROM alpine:latest
LABEL maintainer="Bojan Cekrlic - https://github.com/bokysan/docker-alpine-bootstrap/"

# Install basic set of tools
RUN   \
      apk add --no-cache --upgrade && \
      apk add --no-cache --update \
        bash \
        curl \
        wget \
        unzip \
        tar \
        xz \
        sed \
        gawk \
        vim \
        postgresql-client \
        mariadb-client \
        libressl \
        jq && \
      (rm "/tmp/"* 2>/dev/null || true) && (rm -rf /var/cache/apk/* 2>/dev/null || true)

COPY --from=helm             /usr/local/bin/helm                      /usr/local/bin/
COPY --from=kubectl          /usr/local/bin/kubectl                   /usr/local/bin/
COPY --from=wait-for-service /usr/local/bin/wait-for-service          /usr/local/bin/
COPY --from=wait-for-service /usr/local/bin/fabric8-*                 /usr/local/bin/

COPY  files/* /usr/local/bin/

