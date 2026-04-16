# Golang & PHP Base Images

Docker base images for Go and PHP applications. Supports multi-platform builds (`linux/amd64`, `linux/arm64`).

---

## Go

Base image: `brdnlsrg/baseimage:go-latest`

Built on `golang:1.18-alpine`. Includes:

- `golangci-lint` v1.45.2
- `goveralls` v0.0.11
- `moq` (latest)
- `git`, `bash`, `curl`, `tzdata`
- `coverage.sh` helper script

**Usage example (multi-stage build):**

```dockerfile
FROM brdnlsrg/baseimage:go-latest AS backend

ARG GIT_BRANCH
ARG GITHUB_SHA
ARG CI

ENV GOFLAGS="-mod=vendor"
ENV CGO_ENABLED=0

ADD . /build
WORKDIR /build

RUN go mod vendor

RUN \
    if [ -z "$CI" ]; then \
        version=$(git rev-parse --abbrev-ref HEAD)-$(git log -1 --format=%h)-$(date +%Y%m%dT%H:%M:%S); \
    else \
        version=${GIT_BRANCH}-${GITHUB_SHA:0:7}-$(date +%Y%m%dT%H:%M:%S); \
    fi && \
    echo "version=$version" && \
    cd app && go build -o /app-bin -ldflags "-X main.revision=${version} -s -w"

FROM scratch

COPY --from=backend /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=backend /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=backend /app-bin /srv/app

EXPOSE 8080
WORKDIR /srv
ENTRYPOINT ["/srv/app"]
```

**Build & push:**

```bash
make build_go
make push_go
```

---

## PHP

All PHP images are built on Alpine Linux (except Apache variants — Debian Bookworm) and use multi-stage builds to minimize final image size.

### PHP Extensions (all images)

| Type    | Extensions                                                  |
|---------|-------------------------------------------------------------|
| Core    | `bcmath`, `sockets`, `intl`, `opcache`, `zip`, `pcntl`, `xml` |
| DB      | `mysqli`, `pdo_mysql`, `pdo_pgsql`                          |
| PECL    | `amqp`, `redis`, `ast`                                      |
| Graphics| `gd` (freetype + jpeg)                                      |
| Tools   | `composer`                                                   |

Dev images additionally include: `xdebug`, `supervisor`, `git`.

---

### Available Images

#### PHP 7.4

| Image tag                    | Description              |
|------------------------------|--------------------------|
| `php-light`                  | FPM, lightweight dev     |
| `php-dev-full`               | FPM, full dev            |

#### PHP 8.0

| Image tag                    | Description              |
|------------------------------|--------------------------|
| `php8.0-dev-fpm`             | FPM, dev                 |
| `php8.0-dev-swool`           | Swoole, dev              |

#### PHP 8.1

| Image tag                    | Description              |
|------------------------------|--------------------------|
| `php8.1-dev-fpm`             | FPM, dev                 |
| `php8.1-dev-cli-utils`       | CLI with utils (Composer tools) |
| `php8.1-mysql-dev-fpm`       | FPM + MySQL, dev         |
| `php8.1-mysql-dev-cli`       | CLI + MySQL, dev         |
| `php8.1-mysql-prod-fpm`      | FPM + MySQL, production  |
| `php8.1-mysql-prod-cli`      | CLI + MySQL, production  |

#### PHP 8.2

| Image tag                    | Description              |
|------------------------------|--------------------------|
| `php8.2-mysql-dev-fpm`       | FPM + MySQL, dev         |
| `php8.2-mysql-dev-cli`       | CLI + MySQL, dev         |
| `php8.2-mysql-prod-fpm`      | FPM + MySQL, production  |
| `php8.2-mysql-prod-cli`      | CLI + MySQL, production  |
| `php8.2-pgsql-dev-fpm`       | FPM + PostgreSQL, dev    |
| `php8.2-pgsql-dev-cli`       | CLI + PostgreSQL, dev    |
| `php8.2-pgsql-prod-fpm`      | FPM + PostgreSQL, production |
| `php8.2-pgsql-prod-cli`      | CLI + PostgreSQL, production |

#### PHP 8.3

| Image tag / path                        | Description                              |
|-----------------------------------------|------------------------------------------|
| `build.php/php8.3/dev/fpm`             | FPM, dev                                 |
| `build.php/php8.3/dev/cli`             | CLI, dev                                 |
| `build.php/php8.3/prod/fpm`            | FPM, production (Alpine)                 |
| `build.php/php8.3/prod/cli`            | CLI, production (Alpine)                 |
| `build.php/php8.3/prod-apache/fpm`     | FPM + Apache (Debian Bookworm)           |
| `build.php/php8.3/prod-franken`        | [FrankenPHP](https://frankenphp.dev) 8.3.11-alpine |
| `build.php/php8.3/prod-nginx/fpm`      | FPM + custom-compiled Nginx 1.25.2       |

**Nginx 1.25.2** build includes modules:
- `ngx_http_geoip2_module`
- `headers-more-nginx-module`
- `lua-nginx-module` (LuaJIT)
- `ModSecurity-nginx`
- `ngx_brotli`
- `nginx_cookie_flag_module`

#### PHP 8.4

| Image tag / path                        | Description                              |
|-----------------------------------------|------------------------------------------|
| `build.php/php8.4/dev/fpm`             | FPM, dev                                 |
| `build.php/php8.4/dev/cli`             | CLI, dev                                 |
| `build.php/php8.4/dev/caddy`           | FPM + Caddy, dev                         |
| `build.php/php8.4/prod/fpm`            | FPM, production (Alpine, multi-stage)    |
| `build.php/php8.4/prod/cli`            | CLI, production (Alpine, multi-stage)    |
| `build.php/php8.4/prod/caddy`          | FPM + Caddy, production (multi-stage)    |
| `build.php/php8.4/prod-apache/fpm`     | FPM + Apache (Debian Bookworm)           |

---

### Building

**Single platform:**

```bash
docker build --platform linux/amd64 \
  -t brdnlsrg/baseimage:php8.4-prod-fpm \
  build.php/php8.4/prod/fpm
```

**Multi-platform (buildx):**

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t brdnlsrg/baseimage:php8.4-prod-fpm \
  --push \
  build.php/php8.4/prod/fpm
```

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t brdnlsrg/baseimage:php8.3-prod-fpm \
  --push \
  build.php/php8.3/prod/fpm
```

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm64/v8 \
  -t brdnlsrg/baseimage:php8.2-pgsql-prod-fpm \
  --push \
  build.php/php8.2-pgsql-prod-fpm
```

---

### Makefile targets

```bash
make build_go             # Build Go base image
make push_go              # Push Go image to Docker Hub
make build_php_light      # Build PHP 7.4 light dev image
make push_php_light       # Push PHP light image
make build_php_dev_full   # Build PHP 7.4 full dev image
```
