# What is this?

Use a prebuilt `phpstan` Docker image to analyse Shopware 6 plugins.

# Usage

## On local setups

```bash
docker run --rm -v /path/to/the/plugin:/app aragon999/phpstan-shopware:v6.4.0 analyze --level 5 .
```

## In Github actions

This will use the latest stable Shopware release and the latest PHPStan release.
```yaml
name: Run PHPStan

on:
  push:

jobs:
  phpstan:
    runs-on: ubuntu-latest

    steps:
      - name: Clone
        uses: actions/checkout@v2

      - name: Run PHPStan
        uses: aragon999/phpstan-shopware-docker@master
```
## In Gitlab CI

### Minimal setup

This will use the Shopware version v6.4.0:
```yaml
image:
  name: aragon999/phpstan-shopware:v6.4.0
  entrypoint: [""]

lint:phpstan:
  script:
    - phpstan analyze .
```

### With additional plugin dependencies

When the plugin depends on an additional plugin you need to install the plugin as well, here is a template which includes the Shopware migration plugin which has no publicly available composer packages but exists publicly on Github.

```yaml
lint:phpstan:
  image:
    name: aragon999/phpstan-shopware:v6.4.0
    entrypoint: [""]
  script:
    - phpstan --version
    - composer global config github-oauth.github.com "${GITHUB_OAUTH_TOKEN}"
    - composer global config repositories.swag-migration-assistant vcs https://github.com/shopware/SwagMigrationAssistant.git
    - composer global require swag/migration-assistant:master@dev
    - phpstan analyze .
```

Note that you need to add the `GITHUB_OAUTH_TOKEN` as secret.
