<?php
declare(strict_types=1);

namespace spec\Zalas\Behat\NoExtension\Context\Argument\Fixtures;

class Foo
{
    public function __construct(string $a, string $b, Bar $bar)
    {
    }
}
