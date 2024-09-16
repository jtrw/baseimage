FROM php:8.3-fpm-alpine

# Встановлюємо необхідні пакети для компіляції Nginx та модулів
RUN apk update && apk upgrade && \
    #apk add --no-cache \
    apk add \
    build-base \
    autoconf \
    git \
    unzip \
    bash \
    curl \
    pcre-dev \
    zlib-dev \
    openssl-dev \
    linux-headers \
    libmcrypt-dev \
    icu-dev \
    geoip-dev \
    rabbitmq-c-dev \
    libzip-dev \
    postgresql-dev \
    libmaxminddb-dev \
    luajit-dev \
    brotli-dev \
    libxslt-dev \
    gd-dev
#RUN apk add --no-cache \
RUN apk add \
    pcre \
    zlib \
    openssl \
    geoip \
    libmaxminddb \
    luajit \
    brotli \
    libxslt \
    gd

# Встановлення PHP розширень
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

# Встановлення Composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1
ENV COMPOSER_CACHE_DIR /.composer_cache

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Налаштування для PHP
ADD conf.ini /usr/local/etc/php/conf.d/
RUN chmod +r /usr/local/etc/php/conf.d/conf.ini

ADD opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Встановлюємо користувача nginx
RUN adduser -D -g 'www' www

# Встановлюємо версію Nginx
ENV NGINX_VERSION=1.25.2

# Завантажуємо вихідний код Nginx
RUN wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz \
    && tar -zxvf nginx-$NGINX_VERSION.tar.gz

# Клонуємо необхідні модулі
RUN git clone https://github.com/AirisX/nginx_cookie_flag_module.git \
    && git clone https://github.com/leev/ngx_http_geoip2_module.git \
    && git clone https://github.com/openresty/headers-more-nginx-module.git \
    && git clone https://github.com/openresty/lua-nginx-module.git \
    && git clone --depth=1 https://github.com/SpiderLabs/ModSecurity-nginx.git \
    && git clone https://github.com/google/ngx_brotli.git \
    && git clone https://github.com/LuaJIT/LuaJIT \
    && cd ngx_brotli && git submodule update --init --recursive && cd .. \
    && cd LuaJIT && make install && cd ..

    #&& git clone https://github.com/vision5/ngx_devel_kit.git \
    #&& git clone https://github.com/openresty/luajit2.git \

# Компілюємо та встановлюємо LuaJIT \
RUN export LUAJIT_LIB=/usr/local/lib
RUN export LUAJIT_INC=/usr/local/include/luajit-2.1

# Компілюємо та встановлюємо Nginx з необхідними модулями
RUN cd nginx-$NGINX_VERSION \
    && ./configure \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --user=www \
        --group=www \
        --with-compat \
        --with-file-aio \
        --with-threads \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_mp4_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-stream \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --add-dynamic-module=../nginx_cookie_flag_module \
        --add-dynamic-module=../ngx_http_geoip2_module \
        --add-dynamic-module=../headers-more-nginx-module \
        #--add-dynamic-module=../luajit2 \
        --add-dynamic-module=../lua-nginx-module \
        --add-dynamic-module=../ModSecurity-nginx \
        --add-dynamic-module=../ngx_brotli \
    && make \
    && make install

# Очищуємо тимчасові файли та пакети
RUN cd / \
    && rm -rf nginx-$NGINX_VERSION* \
    && rm -rf nginx_cookie_flag_module \
    && rm -rf ngx_http_geoip2_module \
    && rm -rf headers-more-nginx-module \
    && rm -rf lua-nginx-module \
    && rm -rf ModSecurity-nginx \
    && rm -rf ngx_brotli \
    #&& rm -rf ngx_devel_kit \
    && rm -rf LuaJIT \
    && apk del .build-deps

# Створюємо необхідні директорії
RUN mkdir -p /var/cache/nginx \
    && mkdir -p /etc/nginx/conf.d \
    && chown -R www:www /var/cache/nginx

# Копіюємо конфігураційні файли Nginx
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Завантажуємо модулі в конфігураційний файл
#RUN echo "load_module modules/ngx_http_cookie_flag_filter_module.so;" >> /etc/nginx/nginx.conf \
#    && echo "load_module modules/ngx_http_geoip2_module.so;" >> /etc/nginx/nginx.conf \
#    && echo "load_module modules/ngx_http_headers_more_filter_module.so;" >> /etc/nginx/nginx.conf \
#    && echo "load_module modules/ngx_http_lua_module.so;" >> /etc/nginx/nginx.conf \
#    && echo "load_module modules/ngx_http_modsecurity_module.so;" >> /etc/nginx/nginx.conf \
#    && echo "load_module modules/ngx_stream_geoip2_module.so;" >> /etc/nginx/nginx.conf \
#    && echo "load_module modules/ngx_http_brotli_filter_module.so;" >> /etc/nginx/nginx.conf \
#    && echo "load_module modules/ngx_http_brotli_static_module.so;" >> /etc/nginx/nginx.conf

# Налаштовуємо права доступу
RUN chown -R www:www /etc/nginx

# Відкриваємо порт 80
EXPOSE 80

# Запускаємо Nginx та PHP-FPM
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
