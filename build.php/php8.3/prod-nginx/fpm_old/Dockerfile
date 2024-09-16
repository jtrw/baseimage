ARG PHP_VER

FROM php:8.3-fpm-alpine

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
        gnu-libiconv\
        nginx

RUN pecl install mcrypt amqp redis && \
    docker-php-ext-enable mcrypt amqp redis && \
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

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1
ENV COMPOSER_CACHE_DIR /.composer_cache

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD conf.ini /usr/local/etc/php/conf.d/
RUN chmod +r /usr/local/etc/php/conf.d/conf.ini

ADD opcache.ini /usr/local/etc/php/conf.d/opcache.ini

COPY /nginx/default.conf /etc/nginx/conf.d/default.conf
COPY /nginx/nginx.conf /etc/nginx/nginx.conf

RUN rm -rf /var/cache/apk/* /var/tmp/* /tmp/*

WORKDIR /app

EXPOSE 8080
