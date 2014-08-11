Feature: Importing service definitions
  In order to use services in my contexts
  I needs an easy way to register them
  As an Application Developer

  Scenario: Importing services from a yaml file
    Given a behat configuration:
    """
    default:
      extensions:
        Zalas\Behat\ServiceContainerExtension:
          imports:
            - features/bootstrap/config/services.yml
    """
    And a config file "features/bootstrap/config/services.yml":
    """
    services:
      acme.my_service:
        class: Acme\MyService

      acme.my_service_argument_resolver:
        class: Acme\Argument\MyServiceArgumentResolver
        arguments:
          - @service_container
        tags:
          - { name: context.argument_resolver }
    """
    And a class file "features/bootstrap/Acme/MyService.php":
    """
    <?php

    namespace Acme;

    class MyService
    {
        public function useIt()
        {
        }
    }
    """
    And a class file "features/bootstrap/Acme/Argument/MyServiceArgumentResolver.php":
    """
    <?php

    namespace Acme\Argument;

    use Behat\Behat\Context\Argument\ArgumentResolver;
    use Symfony\Component\DependencyInjection\ContainerInterface;

    class MyServiceArgumentResolver implements ArgumentResolver
    {
        private $container;

        public function __construct(ContainerInterface $container)
        {
            $this->container = $container;
        }

        public function resolveArguments(\ReflectionClass $classReflection, array $arguments)
        {
            $arguments[0] = $this->container->get('acme.my_service');

            return $arguments;
        }
    }
    """
    And a context file "features/bootstrap/FeatureContext.php":
    """
    <?php

    use Acme\MyService;
    use Behat\Behat\Context\Context;

    class FeatureContext implements Context
    {
        private $myService;

        public function __construct(MyService $myService)
        {
            $this->myService = $myService;
        }

        /**
         * @Given my service was injected to the context file
         */
        public function myServiceWasInjectedToTheContextFile()
        {
            if (!$this->myService instanceof MyService) {
                throw new \LogicException('Expected instance of Acme\MyService');
            }
        }

        /**
         * @Then I should be able to use it
         */
         public function iShouldBeAbleToUseIt()
         {
             $this->myService->useIt();
         }
    }
    """
    And a feature file "features/my.feature":
    """
    Feature: My feature

      Scenario:
        Given my service was injected to the context file
        Then I should be able to use it
    """
    When I run behat
    Then it should pass

