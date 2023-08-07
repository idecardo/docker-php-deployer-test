ARG PHP_VERSION=8.2.9

FROM php:${PHP_VERSION}-alpine

COPY --from=composer:2.5.8 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

# Reference for searching module dependencies...
# https://pkgs.alpinelinux.org/contents?file=${FILENAME}
RUN set -ex; \
    apk add --update --no-cache \
        bash \
        openssh-client \
        rsync \
    \
        freetype-dev \
        gettext-dev \
        gmp-dev \
        icu-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libpq-dev \
        libzip-dev \
    ; \
    docker-php-ext-configure intl; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install \
        bcmath \
        exif \
        gd \
        gettext \
        gmp \
        intl \
        pdo_mysql \
        pdo_pgsql \
        zip \
    ; \
    rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/* /var/tmp/*

WORKDIR /var/www
