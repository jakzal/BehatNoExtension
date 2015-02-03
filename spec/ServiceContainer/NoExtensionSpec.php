<?php

namespace spec\Zalas\Behat\NoExtension\ServiceContainer;

use PhpSpec\ObjectBehavior;
use Prophecy\Argument;

class NoExtensionSpec extends ObjectBehavior
{
    function it_is_a_testwork_extension()
    {
        $this->shouldHaveType('Behat\Testwork\ServiceContainer\Extension');
    }

    function it_has_a_config_key()
    {
        $this->getConfigKey()->shouldReturn('no');
    }
}
