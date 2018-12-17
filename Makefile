default: build

build: install test
.PHONY: build

install:
	composer install
.PHONY: install

update:
	composer update
.PHONY: update

update-min:
	composer update --prefer-stable --prefer-lowest
.PHONY: update-min

test: vendor cs phpspec behat
.PHONY: test

test-min: update-min cs phpspec behat
.PHONY: test-min

cs: vendor/bin/php-cs-fixer
	PHP_CS_FIXER_IGNORE_ENV=1 vendor/bin/php-cs-fixer --dry-run --allow-risky=yes --no-interaction --ansi fix
.PHONY: cs

cs-fix: vendor/bin/php-cs-fixer
	PHP_CS_FIXER_IGNORE_ENV=1 vendor/bin/php-cs-fixer --allow-risky=yes --no-interaction --ansi fix
.PHONY: cs-fix

phpspec: vendor/bin/phpspec
	vendor/bin/phpspec run --format=dot
.PHONY: phpunit

behat: vendor/bin/behat
	vendor/bin/behat --format=progress
.PHONY: phpunit

tools: vendor/bin/php-cs-fixer
.PHONY: tools

vendor: install

vendor/bin/behat: install

vendor/bin/phpspec: install

vendor/bin/php-cs-fixer:
	curl -Ls http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -o vendor/bin/php-cs-fixer && chmod +x vendor/bin/php-cs-fixer
