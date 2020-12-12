FROM php:7.4-cli-alpine as BUILD

ARG SHOPWARE_VERSION=dev-master

# Install php extensions needed for Shopware
RUN \
    apk add --no-cache git zlib-dev libpng-dev icu-dev libzip-dev && \
    docker-php-ext-install -j$(nproc) gd intl pdo_mysql zip

ENV COMPOSER_HOME /composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH /composer/vendor/bin:$PATH
ENV PHP_CONF_DIR=/usr/local/etc/php/conf.d

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ARG PHPSTAN_VERSION=latest

# Install composer packages
RUN \
    echo "memory_limit=8192M" > $PHP_CONF_DIR/99_memory-limit.ini && \
    composer global require \
        phpstan/phpstan:"${PHPSTAN_VERSION}" \
        phpunit/phpunit \
        phpstan/phpstan-symfony \
        phpstan/phpstan-phpunit \
        phpstan/extension-installer \

# Cleanup
RUN \
    rm -rf /var/cache/apk/* /var/tmp/* /tmp/* \
    && composer global clearcache
        shopware/core:"${SHOPWARE_VERSION}" \
        shopware/administration:"${SHOPWARE_VERSION}" \
        shopware/storefront:"${SHOPWARE_VERSION}" \
        shopware/elasticsearch:"${SHOPWARE_VERSION}"

FROM scratch

ENV COMPOSER_HOME /composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH /composer/vendor/bin:$PATH
ENV PHP_CONF_DIR=/usr/local/etc/php/conf.d
ENV PHPSTAN_PRO_WEB_PORT=11111

COPY --from=BUILD / /

VOLUME ["/app"]
WORKDIR /app
EXPOSE 11111

ENTRYPOINT ["phpstan"]

CMD ["--version"]
