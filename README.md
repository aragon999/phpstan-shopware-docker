# What is this?

Use a prebuilt `phpstan` Docker image to analyse Shopware 6 plugins.

# Usage

## On local setups

```bash
docker run --rm -v /path/to/the/plugin:/app aragon999/phpstan-shopware:v6.2.0 analyze --level 5 .
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

This will use the Shopware version v6.2.2 with the latest PHPStan:
```yaml
image:
  name: aragon999/phpstan-shopware:v6.2.2
  entrypoint: [""]

lint:plugin:
  script:
    - phpstan analyze .
```
