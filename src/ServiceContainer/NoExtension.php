<?php

namespace Zalas\Behat\NoExtension\ServiceContainer;

use Behat\Testwork\ServiceContainer\Extension;
use Behat\Testwork\ServiceContainer\ExtensionManager;
use Symfony\Component\Config\Definition\Builder\ArrayNodeDefinition;
use Symfony\Component\Config\FileLocator;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Loader\YamlFileLoader;

class NoExtension implements Extension
{
    /**
     * {@inheritdoc}
     */
    public function process(ContainerBuilder $container)
    {
    }

    /**
     * {@inheritdoc}
     */
    public function getConfigKey()
    {
        return 'no';
    }

    /**
     * {@inheritdoc}
     */
    public function initialize(ExtensionManager $extensionManager)
    {
    }

    /**
     * {@inheritdoc}
     */
    public function configure(ArrayNodeDefinition $builder)
    {
        $config = $builder->children();
        $config->arrayNode('imports')->prototype('scalar');
        $config->arrayNode('parameters')->prototype('variable');
    }

    /**
     * {@inheritdoc}
     */
    public function load(ContainerBuilder $container, array $config)
    {
        $basePath = $container->getParameter('paths.base');
        $yamlLoader = new YamlFileLoader($container, new FileLocator($basePath));

        foreach ($config['imports'] as $file) {
            $file = str_replace('%paths.base%', $basePath, $file);
            $yamlLoader->load($file);
        }

        foreach ($config['parameters'] as $name => $value) {
            $container->setParameter($name, $value);
        }
    }
}
