<?php

namespace Zalas\Behat\NoExtension\ServiceContainer;

use Behat\Testwork\ServiceContainer\Extension;
use Behat\Testwork\ServiceContainer\ExtensionManager;
use Symfony\Component\ClassLoader\ClassLoader;
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
    }

    /**
     * {@inheritdoc}
     */
    public function load(ContainerBuilder $container, array $config)
    {
        $this->registerAutoloader($container);

        $basePath = $container->getParameter('paths.base');
        $yamlLoader = new YamlFileLoader($container, new FileLocator($basePath));

        foreach ($config['imports'] as $file) {
            $yamlLoader->load($file);
        }
    }

    /**
     * @param ContainerBuilder $container
     */
    private function registerAutoloader(ContainerBuilder $container)
    {
        $classLoader = new ClassLoader();
        foreach ($container->getParameter('class_loader.prefixes') as $namespace => $path) {
            $classLoader->addPrefix($namespace, str_replace('%paths.base%', $container->getParameter('paths.base'), $path));
        }
        $classLoader->register();
    }
}
