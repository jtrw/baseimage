ARG PHP_VER

FROM php:8.3-apache-bookworm

#RUN apk update && apk upgrade && \
#    apk add --no-cache \
#        build-base \
#        autoconf \
#        automake \
#        linux-headers \
#        curl \
#        libmcrypt-dev \
#        icu-dev \
#        rabbitmq-c-dev \
#        libzip-dev \
#        postgresql-dev \
#        git \
#        unzip \
#        gnupg \
#        bash \
#        curl-dev \
#        oniguruma-dev \
#        freetype \
#        libpng \
#        libjpeg-turbo \
#        freetype-dev \
#        libpng-dev \
#        libjpeg-turbo-dev \
#        libxml2-dev \
#        libmaxminddb-dev \
#        imagemagick \
#        imagemagick-dev \
#        libtool \
#        gnu-libiconv

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    gnupg \
    bash \
    curl \
    librabbitmq-dev \
    mcrypt \
    libxslt-dev \
    libxml2-dev \
    libpam-dev \
    libedit-dev \
    libzip-dev \
    libxml2-dev \
    libmaxminddb-dev \
    libmagickwand-dev \
    libtool



# Install PHP extensions
RUN pecl install amqp redis
RUN docker-php-ext-enable amqp redis


RUN docker-php-ext-install bcmath
RUN docker-php-ext-install sockets
RUN docker-php-ext-install intl
RUN docker-php-ext-install opcache

RUN docker-php-ext-install zip \
        mysqli \
        pdo_mysql \
        pcntl \
        exif
RUN docker-php-ext-configure gd --with-jpeg=/usr/include/ && \
    docker-php-ext-install gd
RUN apt-get clean

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD conf.ini /usr/local/etc/php/conf.d/
RUN chmod +r /usr/local/etc/php/conf.d/conf.ini

ADD opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Supervisor settings
RUN mkdir -p /var/log/supervisor

# Clean cache
RUN apt-get clean

WORKDIR /var/www/html

CMD ["apache2-foreground"]
