ARG PHPSTAN_VERSION=latest

FROM phpstan/phpstan:${PHPSTAN_VERSION}

ARG SHOPWARE_VERSION=dev-master

RUN \
    apk add --no-cache zlib-dev libpng-dev icu-dev libzip-dev \
    && docker-php-ext-install -j$(nproc) gd intl pdo_mysql zip

RUN \
    composer global require phpstan/extension-installer phpstan/phpstan-symfony \
    && composer global require shopware/core:${SHOPWARE_VERSION} shopware/administration:${SHOPWARE_VERSION} shopware/storefront:${SHOPWARE_VERSION}
