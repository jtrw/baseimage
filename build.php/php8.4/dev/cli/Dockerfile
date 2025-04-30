ARG PHP_VER
ARG TZ

FROM php:8.4-cli-alpine AS build

RUN apk update && apk add --no-cache \
    build-base \
    autoconf \
    automake \
    linux-headers \
    curl \
    icu-dev \
    rabbitmq-c-dev \
    libzip-dev \
    postgresql-dev \
    git \
    unzip \
    gnupg \
    supervisor \
    libmcrypt-dev \
    oniguruma-dev \
    freetype \
    libpng \
    libjpeg-turbo \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libxml2-dev \
    libmaxminddb-dev \
    imagemagick \
    imagemagick-dev \
    libtool \
    gnu-libiconv \
 && rm -rf /var/cache/apk/*

# PHP Extensions
RUN docker-php-ext-install \
    bcmath \
    sockets \
    intl \
    opcache \
    zip \
    mysqli \
    pdo_mysql \
    pdo_pgsql \
    pcntl

# PECL Extensions
RUN pecl install amqp redis ast \
 && docker-php-ext-enable amqp redis ast

RUN docker-php-ext-configure gd --with-jpeg=/usr/include/ \
    && docker-php-ext-install gd

# Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_CACHE_DIR=/.composer_cache

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

FROM php:8.4-fpm-alpine AS dev
# Dev dependencies
RUN apk add --no-cache \
    bash \
    git \
    build-base \
    linux-headers \
    gnupg \
    icu-libs \
    libzip \
    rabbitmq-c \
    postgresql-libs \
    supervisor

# Copy everything from base build
COPY --from=build /usr/local/ /usr/local/
# Install Xdebug for dev
#RUN pecl install xdebug \
# && docker-php-ext-enable xdebug \
#    && docker-php-ext-install xdebug \
#    && docker-php-ext-enable xdebug \
#    && docker-php-ext-configure xdebug --enable-xdebug

# Composer ENV
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_CACHE_DIR=/.composer_cache
ARG PHP_VER
ARG TZ
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Supervisor
RUN mkdir -p /var/log/supervisor

# PHP конфігурація
ADD conf.ini /usr/local/etc/php/conf.d/conf.ini
RUN chmod +r /usr/local/etc/php/conf.d/conf.ini

WORKDIR /app
