ARG PHPSTAN_VERSION=latest

FROM phpstan/phpstan:${PHPSTAN_VERSION} as BUILD

ARG SHOPWARE_VERSION=dev-master

# Install php extensions needed for Shopware
RUN \
    apk add --no-cache zlib-dev libpng-dev icu-dev libzip-dev && \
    docker-php-ext-install -j$(nproc) gd intl pdo_mysql zip

# Install composer packages
RUN \
    composer global require \
        phpunit/phpunit \
        phpstan/phpstan-symfony \
        phpstan/phpstan-phpunit \
        phpstan/extension-installer \
        shopware/core:${SHOPWARE_VERSION} \
        shopware/administration:${SHOPWARE_VERSION} \
        shopware/storefront:${SHOPWARE_VERSION} \
        shopware/elasticsearch:${SHOPWARE_VERSION}

# Cleanup
RUN \
    rm -rf /var/cache/apk/* /var/tmp/* /tmp/* \
    && composer global clearcache

FROM scratch

ENV COMPOSER_HOME /composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH /composer/vendor/bin:$PATH
ENV PHP_CONF_DIR=/usr/local/etc/php/conf.d

COPY --from=BUILD / /

VOLUME ["/app"]
WORKDIR /app

ENTRYPOINT ["phpstan"]

CMD ["--version"]
