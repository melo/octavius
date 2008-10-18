use inc::Module::Install;

name     'Protocol-Octavius';
all_from 'lib/Protocol/Octavius.pm';
author   'Pedro Melo <melo@cpan.org>';

build_requires 'Test::More';

auto_install;

WriteAll;

