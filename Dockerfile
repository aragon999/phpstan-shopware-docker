FROM phpstan/phpstan:latest

RUN \
    apk add --no-cache zlib-dev libpng-dev icu-dev libzip-dev \
    && docker-php-ext-install gd intl pdo_mysql zip

RUN \
    composer global require phpstan/extension-installer phpstan/phpstan-symfony \
    && composer global require shopware/core shopware/administration shopware/storefront
