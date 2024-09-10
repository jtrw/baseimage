ARG PHP_VER

FROM php:8.3-cli-alpine

# Оновлення і установка необхідних залежностей
RUN apk update && apk upgrade && \
    apk add --no-cache \
        build-base \
        autoconf \
        automake \
        linux-headers \
        curl \
        libmcrypt-dev \
        icu-dev \
        rabbitmq-c-dev \
        libzip-dev \
        postgresql-dev \
        git \
        unzip \
        gnupg \
        supervisor \
        bash \
        curl-dev \
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
        gnu-libiconv

# Встановлення PHP розширень
RUN pecl install mcrypt amqp redis ast && \
    docker-php-ext-enable mcrypt amqp redis ast && \
    docker-php-ext-install \
        bcmath \
        sockets \
        intl \
        opcache \
        zip \
        pdo_pgsql \
        mysqli \
        pdo_mysql \
        pcntl \
        exif && \
    docker-php-ext-configure gd --with-jpeg=/usr/include/ && \
    docker-php-ext-install gd

# Встановлення Composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1
ENV COMPOSER_CACHE_DIR /.composer_cache

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Налаштування для PHP
ADD conf.ini /usr/local/etc/php/conf.d/
RUN chmod +r /usr/local/etc/php/conf.d/conf.ini

# Налаштування для Supervisor
RUN mkdir -p /var/log/supervisor

# Очищення кешу
RUN rm -rf /var/cache/apk/* /var/tmp/* /tmp/*

WORKDIR /app
