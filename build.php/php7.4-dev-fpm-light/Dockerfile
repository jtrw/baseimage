FROM php:7.4-fpm-alpine
LABEL maintainer="Nil Borodulia <brdnlssrg@gmail.com>"

RUN apk update
RUN apk add --no-cache build-base
RUN apk add --no-cache autoconf
RUN apk add --no-cache automake

# curl for cmd
RUN apk add --no-cache curl

# php extensions

# pdo_pgsql
#RUN apk add --no-cache postgresql-dev
#RUN docker-php-ext-install pdo_pgsql
#RUN docker-php-ext-enable pdo_pgsql

# mysql
RUN docker-php-ext-install mysqli
RUN docker-php-ext-enable mysqli

# pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-enable pdo_mysql

#composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1

#CMD mkdir /.composer_cache
ENV COMPOSER_CACHE_DIR /.composer_cache

RUN apk add --no-cache git unzip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#develop layer
RUN apk add --no-cache gnupg
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN pecl install ast
RUN docker-php-ext-enable ast

# php settings
ADD conf.ini /usr/local/etc/php/conf.d/
RUN chmod +r /usr/local/etc/php/conf.d/conf.ini
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

RUN rm -rf /var/cache/apk/* /var/tmp/* /tmp/*

WORKDIR /app

#USER www-data