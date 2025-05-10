# PHP8.3.20 + GD + Apache2
#
# Creates a development environment for PHP that includes the GD library for image processing.
# If you want to use this in production, uncomment the USER line (Docker containers should not
# be run as root for security reasons, but for local development it is convenient to do so).
#
# Usage: docker build . -t "phpdev"

FROM php:8.3.14-apache

COPY ["./php/php.ini", "/usr/local/etc/php/"]

RUN apt update \
    # Add GD image library to PHP.
    && apt -y upgrade \
    && apt install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd exif \
    # Set permissions on directories.
    && chmod 0755 /var/www \
    && chmod 0755 /var/www/html \
    && chown -R www-data:www-data /var/www/html

# Containers MUST be run as an unprivileged user in production but can specify that in compose.
# If your system does not have www-data user and group, you will need to create one, or
# assign a different user/group both here and in docker-compose.yml
# For local (non-production) development, you can skip the user to avoid permission headaches.
# USER www-data:www-data
