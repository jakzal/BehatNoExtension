<?php
declare(strict_types=1);

namespace spec\Zalas\Behat\NoExtension\ServiceContainer;

use Behat\Testwork\ServiceContainer\Extension;
use PhpSpec\ObjectBehavior;

class NoExtensionSpec extends ObjectBehavior
{
    function it_is_a_testwork_extension()
    {
        $this->shouldHaveType(Extension::class);
    }

    function it_has_a_config_key()
    {
        $this->getConfigKey()->shouldReturn('no');
    }
}
