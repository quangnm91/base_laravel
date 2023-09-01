# #Stage 1: Install package
# FROM composer:2.4.3 as stage1
# WORKDIR /app
# COPY --chown=www-data:www-data ./src .
# USER www-data
# RUN composer install --no-scripts

# FROM node:16-alpine3.18 as stage2
# WORKDIR /app/
# COPY ./src/package.json .
# RUN npm install


FROM php:8.1-rc-fpm-alpine3.18
#Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php && php -r "unlink('composer-setup.php');" && mv composer.phar /usr/local/bin/composer
# COPY --from=stage1 /app /var/www/data
# COPY --from=stage2 /app/node_modules /var/www/data/node_modules
# COPY --chown=www-data:www-data ./src/ .
RUN docker-php-ext-install mysqli pdo pdo_mysql


RUN apk update && apk add \
  curl \
  libpng-dev \
  libxml2-dev \
  zip \
  unzip

#Clear cache
# RUN apk cache clean && rm -rf /var/lib/apt/lists/*

# pdo pdo_mysql 
# pcntl bcmath gd exif

#Create system user to run Composer and Artisan commands

RUN addgroup -g 1000 quangnm
RUN adduser -u 1000 -S quangnm -G quangnm

WORKDIR /var/www/data
COPY --chown=quangnm:quangnm ./src/ .
# CMD chmod 774 -R ./storage

USER quangnm

# CMD composer install
# CMD php artisan optimize