Feature: Importing service definitions
  In order to extend Behat without having to write an extension
  I need to import service definitions
  As a Behat User

  Background:
    Given "Acme" classes are autoloaded from "features/bootstrap/Acme"
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

  Scenario: Importing services from a yaml file
    Given a behat configuration:
    """
    default:
      extensions:
        Zalas\Behat\NoExtension:
          imports:
            - features/bootstrap/config/services.yml
    """
    And a config file "features/bootstrap/config/services.yml":
    """
    services:
      acme.my_service_argument_resolver:
        class: Acme\Argument\MyServiceArgumentResolver
        tags:
          - { name: context.argument_resolver }
    """
    When I run behat
    Then it should pass

  Scenario: Importing services from a xml file
    Given a behat configuration:
    """
    default:
      extensions:
        Zalas\Behat\NoExtension:
          imports:
            - features/bootstrap/config/services.xml
    """
    And a config file "features/bootstrap/config/services.xml":
    """
    <container xmlns="http://symfony.com/schema/dic/services"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://symfony.com/schema/dic/services http://symfony.com/schema/dic/services/services-1.0.xsd">
        <services>
            <service id="acme.my_service_argument_resolver" class="Acme\Argument\MyServiceArgumentResolver">
                <tag name="context.argument_resolver" />
            </service>
        </services>
    </container>
    """
    When I run behat
    Then it should pass

  Scenario: Importing services from a php file
    Given a behat configuration:
    """
    default:
      extensions:
        Zalas\Behat\NoExtension:
          imports:
            - features/bootstrap/config/services.php
    """
    And a config file "features/bootstrap/config/services.php":
    """
    <?php
    $container
        ->register('acme.my_service_argument_resolver', 'Acme\Argument\MyServiceArgumentResolver')
        ->addTag('context.argument_resolver');
    """
    When I run behat
    Then it should pass
