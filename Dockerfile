FROM php:8.1-fpm

RUN apt update && apt install -y \
    git unzip curl gnupg nginx supervisor \
    mariadb-client libonig-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql mbstring zip

COPY . /app
WORKDIR /app/panel

RUN curl -sS https://getcomposer.org/installer | php && \
    php composer.phar install --no-dev --optimize-autoloader

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]