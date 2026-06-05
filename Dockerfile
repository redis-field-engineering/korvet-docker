# Generated with JReleaser 1.25.0-SNAPSHOT at 2026-06-05T14:24:51.158640421Z
# Multi-stage build to avoid duplicate layers

FROM alpine:latest AS extractor

RUN apk add --no-cache unzip

COPY assembly/ /assembly/

RUN unzip /assembly/korvet-cli-0.16.0.zip -d /opt && \
    rm /assembly/korvet-cli-0.16.0.zip && \
    chmod +x /opt/korvet-cli-0.16.0/bin/korvet-cli

FROM azul/zulu-openjdk-alpine:25-jre

LABEL "org.opencontainers.image.title"="korvet-cli"
LABEL "org.opencontainers.image.description"="Kafka-compatible streaming service with automatic local/remote data tiering"
LABEL "org.opencontainers.image.url"="https://github.com/redis-field-engineering/korvet-dist"
LABEL "org.opencontainers.image.licenses"="Apache-2.0"
LABEL "org.opencontainers.image.version"="0.16.0"
LABEL "org.opencontainers.image.revision"="45371a75b6f30844d50915170f4b3c1889aa83ba"
LABEL "org.opencontainers.image.source"="https://github.com/redis-field-engineering/korvet-docker"


COPY --from=extractor /assembly /
COPY --from=extractor /opt/korvet-cli-0.16.0 /korvet-cli


ENV PATH="${PATH}:/korvet-cli/bin"

ENTRYPOINT ["/korvet-cli/bin/korvet-cli"]
