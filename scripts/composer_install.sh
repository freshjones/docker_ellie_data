#!/bin/bash

echo "cd into app"
cd /app/laravel

echo "authorize github-oauth"
composer config -g github-oauth.github.com b5a3ac9fb28d24911e1a4b0837bde70b9cbc696f

echo "run composer install"
composer install --prefer-dist

echo "copy the env variables"
cp .env.example .env