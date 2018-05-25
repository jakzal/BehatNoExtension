<?php
declare(strict_types=1);

namespace Zalas\Behat\NoExtension\ServiceContainer;

use Behat\Testwork\ServiceContainer\Extension;
use Behat\Testwork\ServiceContainer\ExtensionManager;
use Psr\Container\ContainerInterface;
use Symfony\Component\Config\Definition\Builder\ArrayNodeDefinition;
use Symfony\Component\Config\FileLocator;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Loader\YamlFileLoader;
use Symfony\Component\DependencyInjection\Reference;
use Zalas\Behat\NoExtension\Context\Argument\ServiceArgumentResolver;

class NoExtension implements Extension
{
    public function process(ContainerBuilder $container)
    {
    }

    public function getConfigKey()
    {
        return 'no';
    }

    public function initialize(ExtensionManager $extensionManager)
    {
    }

    public function configure(ArrayNodeDefinition $builder)
    {
        $config = $builder->children();
        $config->arrayNode('imports')->prototype('scalar');
        $config->arrayNode('parameters')->prototype('variable');
        $config->booleanNode('argument_resolver');
    }

    public function load(ContainerBuilder $container, array $config)
    {
        $this->loadImports($container, $config);
        $this->loadParameters($container, $config);
        $this->loadArgumentResolver($container, $config);
    }

    private function loadImports(ContainerBuilder $container, array $config): void
    {
        $basePath = $container->getParameter('paths.base');
        $yamlLoader = new YamlFileLoader($container, new FileLocator($basePath));

        foreach ($config['imports'] as $file) {
            $file = \str_replace('%paths.base%', $basePath, $file);
            $yamlLoader->load($file);
        }
    }

    private function loadParameters(ContainerBuilder $container, array $config): void
    {
        foreach ($config['parameters'] as $name => $value) {
            $container->setParameter($name, $value);
        }
    }

    private function loadArgumentResolver(ContainerBuilder $container, array $config): void
    {
        if ($config['argument_resolver']) {
            $container->register(ServiceArgumentResolver::class)
                ->addArgument(new Reference(ContainerInterface::class))
                ->addTag('context.argument_resolver');
        }
    }
}
