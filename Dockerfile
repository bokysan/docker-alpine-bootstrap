FROM alpine:edge
LABEL maintainer="Bojan Cekrlic - https://github.com/bokysan/docker-alpine-bootstrap/"

# See README.md for details

# Install basic set of tools
RUN        true && \
           apk add --no-cache --upgrade && \
           apk add --no-cache --update bash curl wget unzip tar xz sed gawk vim postgresql-client libressl && \
           (rm "/tmp/"* 2>/dev/null || true) && (rm -rf /var/cache/apk/* 2>/dev/null || true)
