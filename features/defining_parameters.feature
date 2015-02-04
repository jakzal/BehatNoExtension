Feature: Defining parameters
  In order to avoid duplication in my configuration
  I need to define parameters
  As a Behat User

  Scenario: Defining parameters
    Given a behat configuration:
    """
    default:
      suites:
        acme:
          contexts:
            - FeatureContext:
                answers: %answers%
      extensions:
        Zalas\Behat\NoExtension:
          imports:
            - features/bootstrap/config/services.yml
    """
    And a config file "features/bootstrap/config/services.yml":
    """
    parameters:
      answers: {"a": "foo", "b": bazinga!}
    """
    And a context file "features/bootstrap/FeatureContext.php":
    """
    <?php

    use Behat\Behat\Context\Context;

    class FeatureContext implements Context
    {
        private $answers;
        private $answer;

        public function __construct($answers = null)
        {
            $this->answers = $answers;
        }

        /**
         * @Given I select :answer
         */
        public function iSelect($answer)
        {
            $this->answer = $answer;
        }

        /**
         * @Then I should see :message
         */
         public function iShouldSee($message)
         {
            if ($message !== $this->answers[$this->answer]) {
                throw new \LogicException(sprintf('Expected "%s", but got "%s"', $message, $this->answers[$this->answer]));
            }
         }
    }
    """
    And a feature file "features/my.feature":
    """
    Feature: My feature

      Scenario:
        Given I select "b"
        Then I should see "bazinga!"
    """
    When I run behat
    Then it should pass

  Scenario: Defining parameters in behat.yml
    Given a behat configuration:
    """
    default:
      suites:
        acme:
          contexts:
            - FeatureContext:
                answers: %answers%
      extensions:
        Zalas\Behat\NoExtension:
          parameters:
            answers:
              a: foo
              b: bazinga!
    """
    And a context file "features/bootstrap/FeatureContext.php":
    """
    <?php

    use Behat\Behat\Context\Context;

    class FeatureContext implements Context
    {
        private $answers;
        private $answer;

        public function __construct($answers = null)
        {
            $this->answers = $answers;
        }

        /**
         * @Given I select :answer
         */
        public function iSelect($answer)
        {
            $this->answer = $answer;
        }

        /**
         * @Then I should see :message
         */
         public function iShouldSee($message)
         {
            if ($message !== $this->answers[$this->answer]) {
                throw new \LogicException(sprintf('Expected "%s", but got "%s"', $message, $this->answers[$this->answer]));
            }
         }
    }
    """
    And a feature file "features/my.feature":
    """
    Feature: My feature

      Scenario:
        Given I select "b"
        Then I should see "bazinga!"
    """
    When I run behat
    Then it should pass
