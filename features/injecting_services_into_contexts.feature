Feature: Injecting services into contexts
  In order to make the maintenance of my contexts easier
  I need to delegate creation of context dependencies
  As a Behat User

  Background:
    Given a behat configuration:
    """
    default:
      extensions:
        Zalas\Behat\NoExtension:
          argument_resolver: true
          imports:
            - features/bootstrap/config/services.yml
    """
    And "Acme" classes are autoloaded from "features/bootstrap/Acme"

  Scenario: Service class name matches the argument's type hint
    Given a config file "features/bootstrap/config/services.yml":
    """
    services:
      Acme\Foo:
        public: true
    """
    And a class file "features/bootstrap/Acme/Foo.php":
    """
    <?php

    namespace Acme;

    class Foo
    {
        public function useIt() {}
    }
    """
    And a context file "features/bootstrap/FeatureContext.php":
    """
    <?php

    use Acme\Foo;
    use Behat\Behat\Context\Context;

    class FeatureContext implements Context
    {
        private $foo;

        public function __construct(Foo $foo = null)
        {
            $this->foo = $foo;
        }

        /**
         * @Given my service was injected to the context file
         */
        public function myServiceWasInjectedToTheContextFile()
        {
            if (!$this->foo instanceof Foo) {
                throw new \LogicException('Expected instance of Acme\Foo');
            }
        }

        /**
         * @Then I should be able to use it
         */
         public function iShouldBeAbleToUseIt()
         {
             $this->foo->useIt();
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
