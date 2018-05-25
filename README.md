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
* PHP ^7.1

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

Injecting services into contexts
--------------------------------

Enable the argument resolver to take advantage of the built in support for service injection:

```yaml
# behat.yml
default:
  extensions:
    Zalas\Behat\NoExtension:
      argument_resolver: true
      imports:
        - features/bootstrap/config/services.yml
```

Assuming services you'd like to inject into contexts are defined in `features/bootstrap/Acme`,
and they're autoloaded by composer, you can now start defining them in your configuration file:

```yaml
# features/bootstrap/config/services.yml
services:

    Acme\:
        resource: '../Acme'
        public: true
        autowire: true
```

The above example relies on autoworing, but you could also define each service explicitly.

An example composer autoloader configuration:

```json
{
    "autoload-dev": {
        "psr-4": {
            "Acme\\": "features/bootstrap/Acme"
        }
    }
}
```

Given there's a class `Acme\Foo` defined, it can now be injected into contexts:

```php
use Acme\Foo;
use Behat\Behat\Context\Context;

class FeatureContext implements Context
{
    private $foo;

    public function __construct(Foo $foo)
    {
        $this->foo = $foo;
    }
}
```

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

