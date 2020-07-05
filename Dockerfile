ARG PHPSTAN_VERSION=latest

FROM phpstan/phpstan:${PHPSTAN_VERSION} as BUILD

ARG SHOPWARE_VERSION=dev-master

# Install php extensions needed for Shopware
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions gd intl pdo_mysql zip

# Install composer packages
RUN \
    composer global require \
        phpstan/extension-installer \
        phpstan/phpstan-symfony \
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
