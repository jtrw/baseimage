FROM golang:1.18-alpine
LABEL maintainer="Nil Borodulia <brdnlsrg@gmail.com>"

ENV \
    TIME_ZONE=Europe/London   \
    CGO_ENABLED=0               \
    GOVERALLS=0.0.11            \
    GOLANGCI=1.45.2             \
    STATIK=0.1.7                \
    GORELEASER=1.8.3

RUN \
    apk add --no-cache --update tzdata git bash curl && \
    echo "${TIME_ZONE}" > /etc/timezone && \
    cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && \
    date && \
    rm -rf /var/cache/apk/*

RUN \
    go version && \
    go install github.com/matryer/moq@latest && moq -version

RUN \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@v${GOLANGCI} && \
    golangci-lint --version

RUN go install github.com/mattn/goveralls@v${GOVERALLS} && which goveralls

ADD coverage.sh /script/coverage.sh

RUN chmod +x /script/coverage.sh