#!/bin/bash

mkdir -p /app/var
touch /app/var/.env

echo "APP_KEY=" >> /app/var/.env

cd /app/panel

php artisan key:generate --force
php artisan storage:link || true

echo "Waiting for MySQL..."
until nc -z $DB_HOST $DB_PORT; do
  sleep 2
  echo "Waiting..."
done

php artisan migrate --seed --force

php artisan p:user:make \
  --email="${ADMIN_EMAIL}" \
  --username="${ADMIN_USERNAME}" \
  --password="${ADMIN_PASSWORD}" \
  --admin=1 || true

php-fpm &
nginx -g "daemon off;"