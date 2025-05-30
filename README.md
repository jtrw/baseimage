# Golang, PHP Base image

## Go

```
FROM brdnlsrg/baseimage:go-latest as backend

ARG GIT_BRANCH
ARG GITHUB_SHA
ARG CI

ENV GOFLAGS="-mod=vendor"
ENV CGO_ENABLED=0

ADD . /build
WORKDIR /build

RUN apk add --no-cache --update git tzdata ca-certificates

RUN go mod vendor

RUN \
    if [ -z "$CI" ] ; then \
    echo "runs outside of CI" && version=$(git rev-parse --abbrev-ref HEAD)-$(git log -1 --format=%h)-$(date +%Y%m%dT%H:%M:%S); \
    else version=${GIT_BRANCH}-${GITHUB_SHA:0:7}-$(date +%Y%m%dT%H:%M:%S); fi && \
    echo "version=$version"

RUN cd app && go build -o /echo-http -ldflags "-X main.revision=${version} -s -w"

FROM scratch

COPY --from=backend /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=backend /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=backend /echo-http /srv/echo-http

EXPOSE 8080
WORKDIR /srv
ENTRYPOINT ["/srv/echo-http"]
```

## PHP

`FROM brdnlsrg/baseimage:php-light`

Include

1. curl
1. mysql
1. composer
1. xdebug

`FROM brdnlsrg/baseimage:php8.1-full-dev-mysql`

`FROM brdnlsrg/baseimage:php8.1-full-dev`

`FROM brdnlsrg/baseimage:php8.0-full-dev`

`FROM brdnlsrg/php8.1-mysql-prod-cli`

`FROM brdnlsrg/php8.1-mysql-prod-fpm`

`FROM brdnlsrg/php8.1-mysql-dev-cli`

`FROM brdnlsrg/php8.2-mysql-dev-fpm`

`FROM brdnlsrg/php8.2-mysql-dev-cli`

`FROM brdnlsrg/php8.2-mysql-prod-cli`

`FROM brdnlsrg/php8.2-mysql-prod-fpm`

`FROM brdnlsrg/php8.2-pgsql-dev-fpm`

`FROM brdnlsrg/php8.2-pgsql-dev-cli`

`FROM brdnlsrg/php8.2-pgsql-prod-cli`

`FROM brdnlsrg/php8.2-pgsql-prod-fpm`

### Cross platform

```
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t brdnlsrg/baseimage:php8.2-pgsql-prod-fpm --push .
```

```
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t brdnlsrg/baseimage:php8.3-dev-fpm --push .
```

```
docker buildx build --platform linux/amd64,linux/arm64 -t brdnlsrg/baseimage:php8.4-dev-fpm --push .
```
