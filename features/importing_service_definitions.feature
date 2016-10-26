Feature: Importing service definitions
  In order to extend Behat without having to write an extension
  I need to import service definitions
  As a Behat User

  Scenario: Importing services from a yaml file
    Given a behat configuration:
    """
    default:
      extensions:
        Zalas\Behat\NoExtension:
          imports:
            - %paths.base%/features/bootstrap/config/services.yml
    """
    And a config file "features/bootstrap/config/services.yml":
    """
    services:
      acme.my_service_argument_resolver:
        class: Acme\Argument\MyServiceArgumentResolver
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

    use Acme\MyService;
    use Behat\Behat\Context\Argument\ArgumentResolver;
    use Symfony\Component\DependencyInjection\ContainerInterface;

    class MyServiceArgumentResolver implements ArgumentResolver
    {
        public function resolveArguments(\ReflectionClass $classReflection, array $arguments)
        {
            foreach ($classReflection->getConstructor()->getParameters() as $i => $parameter) {
                if ('Acme\MyService' === $parameter->getClass()->getName()) {
                    $arguments[$i] = new MyService();
                }
            }

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

        public function __construct(MyService $myService = null)
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

