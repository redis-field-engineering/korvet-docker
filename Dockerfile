# Generated with JReleaser 1.25.0-SNAPSHOT at 2026-06-04T01:25:29.284259381Z
# Multi-stage build to avoid duplicate layers

FROM alpine:latest AS extractor

RUN apk add --no-cache unzip

COPY assembly/ /assembly/

RUN unzip /assembly/korvet-cli-0.15.1.zip -d /opt && \
    rm /assembly/korvet-cli-0.15.1.zip && \
    chmod +x /opt/korvet-cli-0.15.1/bin/korvet-cli

FROM azul/zulu-openjdk-alpine:25-jre

LABEL "org.opencontainers.image.title"="korvet-cli"
LABEL "org.opencontainers.image.description"="Kafka-compatible streaming service with automatic local/remote data tiering"
LABEL "org.opencontainers.image.url"="https://github.com/redis-field-engineering/korvet-dist"
LABEL "org.opencontainers.image.licenses"="Apache-2.0"
LABEL "org.opencontainers.image.version"="0.15.1"
LABEL "org.opencontainers.image.revision"="20349dc41c3df5507511532c30a760bb23d720a0"
LABEL "org.opencontainers.image.source"="https://github.com/redis-field-engineering/korvet-docker"


COPY --from=extractor /assembly /
COPY --from=extractor /opt/korvet-cli-0.15.1 /korvet-cli


ENV PATH="${PATH}:/korvet-cli/bin"

ENTRYPOINT ["/korvet-cli/bin/korvet-cli"]
