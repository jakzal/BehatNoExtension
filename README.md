Behat No Extension
==================

[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/jakzal/BehatNoExtension/badges/quality-score.png?b=master)](https://scrutinizer-ci.com/g/jakzal/BehatNoExtension/?branch=master)
[![Build Status](https://scrutinizer-ci.com/g/jakzal/BehatNoExtension/badges/build.png?b=master)](https://scrutinizer-ci.com/g/jakzal/BehatNoExtension/build-status/master)

This Behat extension makes it possible to extend Behat without needing to write
extension yourself.


Installation
------------

This extension requires:

* Behat 3.0+
* PHP 5.3+

The easiest way to install it is to use Composer

```
$ composer require --dev zalas/behat-no-extension:^1.0
```

Next, activate the extension in your ``behat.yml``:

```yaml
# behat.yml
default:
  extensions:
    Zalas\Behat\NoExtension: ~
```

Importing service definitions
-----------------------------

Extension enables you to load service definitions and parameters from
configuration files specified in the ``imports`` section:

```yaml
# behat.yml
default:
  extensions:
    Zalas\Behat\NoExtension:
      imports:
        - features/bootstrap/config/services.yml
```

These should simply be
[Symfony's service container](http://symfony.com/doc/current/components/dependency_injection/introduction.html#setting-up-the-container-with-configuration-files)
configuration files:

```yaml
# features/bootstrap/config/services.yml
services:
  acme.simple:
    class: Acme\SimpleArgumentResolver
    tags:
      - { name: context.argument_resolver }

parameters:
  acme.foo: boo!
```

Parameters defined in such a way are also available in ``behat.yml``:

```yaml
# behat.yml
default:
  suites:
    search:
      contexts:
        - SearchContext:
            myFoo: %acme.foo%
  # ...
```

