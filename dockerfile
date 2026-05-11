FROM php:5.6-fpm-stretch

LABEL maintainer="Rezky Yuranda"
LABEL org.opencontainers.image.title="PHP 5.6 Oracle Legacy"
LABEL org.opencontainers.image.description="PHP 5.6 FPM with Oracle Instant Client and OCI8 for legacy web applications"
LABEL org.opencontainers.image.version="webkampus-v1"
LABEL org.opencontainers.image.vendor="Atma Luhur"
LABEL org.opencontainers.image.source="https://github.com/terserah/php56-oracle"

RUN echo "deb http://archive.debian.org/debian stretch main" \
    > /etc/apt/sources.list

RUN printf 'Acquire::Check-Valid-Until "false";\n\
Acquire::AllowInsecureRepositories "true";\n\
Acquire::AllowDowngradeToInsecureRepositories "true";\n\
APT::Get::AllowUnauthenticated "true";\n' \
> /etc/apt/apt.conf.d/99legacy


RUN apt update && apt install -y \
    unzip \
    wget \
    curl \
    git \
    libaio1 \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    gcc \
    make \
    g++ \
    pkg-config

RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
    gd \
    mysqli \
    mysql \
    pdo \
    pdo_mysql \
    mbstring \
    zip \
    exif \
    dom \
    curl

COPY instantclient/instantclient-basic-linux.x64-11.2.0.4.0.zip /tmp/basic.zip
COPY instantclient/instantclient-sdk-linux.x64-11.2.0.4.0.zip /tmp/sdk.zip

RUN unzip /tmp/basic.zip -d /usr/local/ \
    && unzip /tmp/sdk.zip -d /usr/local/ \
    && ln -s /usr/local/instantclient_11_2 /usr/local/instantclient \
    && ln -s /usr/local/instantclient/libclntsh.so.11.1 /usr/local/instantclient/libclntsh.so \
    && echo "/usr/local/instantclient" > /etc/ld.so.conf.d/oracle.conf \
    && ldconfig


RUN echo 'instantclient,/usr/local/instantclient' \
    | pecl install oci8-2.0.12 \
    && docker-php-ext-enable oci8


RUN pecl install redis-4.3.0 \
    && docker-php-ext-enable redis

#COPY php.ini /usr/local/etc/php/php.ini


ENV LD_LIBRARY_PATH="/usr/local/instantclient"

WORKDIR /var/www/html

EXPOSE 9000

CMD ["php-fpm"]
