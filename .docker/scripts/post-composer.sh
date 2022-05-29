#!/bin/bash

if grep -Fxq "APP_KEY=" .env; then
    php artisan key:generate
fi

php artisan optimize:clear

php artisan view:cache
php artisan route:cache
php artisan config:cache
php artisan package:discover
php artisan optimize
