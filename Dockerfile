FROM php:alpine

# PHP
RUN apk add --update --no-cache \
    freetype \
    freetype-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    libpng \
    libpng-dev \
    libtool \
    libxml2-dev \
    libzip-dev \
    openssh-client \
    rsync \
    # Configure extensions
    && docker-php-ext-configure \
    gd \
    --with-freetype-dir=/usr \
    --with-jpeg-dir=/usr \
    --with-png-dir=/usr \
    && docker-php-ext-configure \
    zip --with-libzip \
    # Install extensions
    && docker-php-ext-install \
    gd \
    pcntl \
    pdo_mysql \
    zip \
    # Delete dependencies
    && apk del --no-cache \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    && rm -rf /var/cache/apk/*

# Composer
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="./vendor/bin:$PATH"

WORKDIR /var/www
