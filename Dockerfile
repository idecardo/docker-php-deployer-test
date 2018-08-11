FROM php:alpine

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    PATH="./vendor/bin:$PATH"

RUN apk add --update --no-cache \
    bash \
    openssh-client \
    rsync

RUN apk add --update --no-cache -t .persistent-deps \
        # for bz2 extension
        bzip2-dev \
        # for gd --with-freetype-dir option
        freetype-dev \
        # for gmp extension
        gmp-dev \
        # for gd --with-jpeg-dir option
        libjpeg-turbo-dev \
        # for gd --with-png-dir option
        libpng-dev \
        # for zip extension
        libzip-dev \
    # Environment
    && set -xe \
    # Configure
    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include \
        --with-jpeg-dir=/usr/include \
        --with-png-dir=/usr/include \
    && docker-php-ext-configure zip \
        --with-libzip \
    && docker-php-ext-install \
        bcmath \
        bz2 \
        exif \
        gd \
        gmp \
        pdo_mysql \
        zip \
    # Composer
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
    # Cleanup
    && apk del --no-cache \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
    && rm -rf \
        /tmp/* \
        /var/cache/apk/* \
        /var/tmp/*

WORKDIR /var/www
