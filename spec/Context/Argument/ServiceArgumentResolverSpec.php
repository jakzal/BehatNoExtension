<?php
declare(strict_types=1);

namespace spec\Zalas\Behat\NoExtension\Context\Argument;

use Behat\Behat\Context\Argument\ArgumentResolver;
use PhpSpec\ObjectBehavior;
use Psr\Container\ContainerInterface;
use Psr\Container\NotFoundExceptionInterface;
use ReflectionClass;
use RuntimeException;
use spec\Zalas\Behat\NoExtension\Context\Argument\Fixtures\Bar;
use spec\Zalas\Behat\NoExtension\Context\Argument\Fixtures\Foo;
use spec\Zalas\Behat\NoExtension\Context\Argument\Fixtures\FooWithNoConstructor;

class ServiceArgumentResolverSpec extends ObjectBehavior
{
    function let(ContainerInterface $container)
    {
        $this->beConstructedWith($container);
    }

    function it_is_an_argument_resolver()
    {
        $this->shouldHaveType(ArgumentResolver::class);
    }

    function it_ignores_classes_with_no_constructors()
    {
        $class = new ReflectionClass(FooWithNoConstructor::class);

        $this->resolveArguments($class, ['a', 'b', 'c'])->shouldReturn(['a', 'b', 'c']);
    }

    function it_replaces_the_argument_if_it_is_found_in_container_by_type(ContainerInterface $container, Bar $bar)
    {
        $container->has(Bar::class)->willReturn(true);
        $container->get(Bar::class)->willReturn($bar);

        $class = new ReflectionClass(Foo::class);

        $this->resolveArguments($class, ['a', 'b', 'c'])->shouldReturn(['a', 'b', $bar]);
    }

    function it_does_not_replace_an_argument_if_service_is_not_found_in_the_container(ContainerInterface $container, Bar $bar)
    {
        $container->has(Bar::class)->willReturn(false);
        $container->get(Bar::class)->willThrow(new class extends RuntimeException implements NotFoundExceptionInterface {
        });

        $class = new ReflectionClass(Foo::class);

        $this->resolveArguments($class, ['a', 'b', 'c'])->shouldReturn(['a', 'b', 'c']);
    }
}
