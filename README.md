Behat No Extension
==================

[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/jakzal/BehatNoExtension/badges/quality-score.png?b=master)](https://scrutinizer-ci.com/g/jakzal/BehatNoExtension/?branch=master)
[![Build Status](https://scrutinizer-ci.com/g/jakzal/BehatNoExtension/badges/build.png?b=master)](https://scrutinizer-ci.com/g/jakzal/BehatNoExtension/build-status/master)
[![Build Status](https://travis-ci.org/jakzal/BehatNoExtension.svg?branch=master)](https://travis-ci.org/jakzal/BehatNoExtension)

This Behat extension makes it possible to extend Behat without needing to write
extension yourself.


Installation
------------

This extension requires:

* Behat ^3.0
* PHP ^7.0

The easiest way to install it is to use Composer

```
$ composer require --dev zalas/behat-no-extension
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

Note that any classes you'd like to use should be autoloaded by composer.
For the example above, `autoload-dev` or `autoload` should include the `Acme\\` autoloader prefix.

Defining parameters
-------------------

Parameters defined in imported files are also available in ``behat.yml``:

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

Furthermore, parameters can also be defined as part of extension's configuration directly in ``behat.yml``:

```yaml
# behat.yml
default:
  extensions:
    Zalas\Behat\NoExtension:
      parameters:
        foo: bar
        baz:
          a: 1
          b: bazinga!
```

