<?php
declare(strict_types=1);

namespace Zalas\Behat\NoExtension\Context\Argument;

use Behat\Behat\Context\Argument\ArgumentResolver;
use Psr\Container\ContainerInterface;
use ReflectionClass;
use ReflectionMethod;

/**
 * Resolves context arguments with services found in a psr container.
 */
final class ServiceArgumentResolver implements ArgumentResolver
{
    private $container;

    public function __construct(ContainerInterface $container)
    {
        $this->container = $container;
    }

    public function resolveArguments(ReflectionClass $classReflection, array $arguments): array
    {
        if ($constructor = $classReflection->getConstructor()) {
            return $this->resolveConstructorArguments($constructor, $arguments);
        }

        return $arguments;
    }

    private function resolveConstructorArguments(ReflectionMethod $constructor, array $arguments): array
    {
        $constructorParameters = $constructor->getParameters();

        foreach ($constructorParameters as $position => $parameter) {
            if ($parameter->getClass() && $service = $this->resolve($parameter->getClass())) {
                $arguments[$position] = $service;
            }
        }

        return $arguments;
    }

    private function resolve(ReflectionClass $class)
    {
        if ($this->container->has($class->getName())) {
            return $this->container->get($class->getName());
        }
    }
}
