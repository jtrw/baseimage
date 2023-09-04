FROM composer:latest as composer

COPY composer.* /app/

RUN set -xe \
 && composer install --no-dev --no-scripts --no-suggest --no-interaction --prefer-dist --optimize-autoloader

COPY . /app

RUN composer dump-autoload --no-dev --optimize --classmap-authoritative

FROM php:8.1-cli-alpine

RUN apk update
RUN apk add --no-cache build-base
RUN apk add --no-cache autoconf
RUN apk add --no-cache automake

COPY . /app

COPY --from=composer /app/vendor /app/vendor

WORKDIR /app
