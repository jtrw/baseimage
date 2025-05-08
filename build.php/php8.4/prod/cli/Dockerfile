ARG PHP_VER
ARG TZ

# Build stage
FROM php:8.4-cli-alpine AS build

# Встановлення залежностей для збірки
RUN apk add --no-cache \
    build-base \
    autoconf \
    automake \
    libtool \
    linux-headers \
    curl \
    git \
    unzip \
    gnupg \
    icu-dev \
    rabbitmq-c-dev \
    libzip-dev \
    postgresql-dev \
    libmcrypt-dev \
    oniguruma-dev \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libxml2-dev \
    imagemagick-dev

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
    pcntl \
    xml

# PECL Extensions
RUN pecl install amqp redis ast \
 && docker-php-ext-enable amqp redis ast

# GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install gd

# Composer
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_MEMORY_LIMIT=-1 \
    COMPOSER_CACHE_DIR=/.composer_cache

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Production stage
FROM php:8.4-fpm-alpine AS prod

# Runtime dependencies only
RUN apk add --no-cache \
    bash \
    icu-libs \
    libzip \
    rabbitmq-c \
    postgresql-libs \
    freetype \
    libpng \
    libjpeg-turbo \
    supervisor \
    imagemagick \
    oniguruma \
    libxml2 \
    gnu-libiconv

# Копіюємо зібрані файли
COPY --from=build /usr/local/ /usr/local/
COPY --from=build /root/.composer /root/.composer

# Налаштування середовища
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_MEMORY_LIMIT=-1 \
    COMPOSER_CACHE_DIR=/.composer_cache

ARG PHP_VER
ARG TZ
ENV TZ=${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Supervisor
RUN mkdir -p /var/log/supervisor

# PHP Configuration
ADD conf.ini /usr/local/etc/php/conf.d/
ADD opcache.ini /usr/local/etc/php/conf.d/

RUN chmod +r /usr/local/etc/php/conf.d/*.ini

WORKDIR /app
