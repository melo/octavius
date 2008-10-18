use inc::Module::Install;

name     'AnyEvent-Octavius';
all_from 'lib/AnyEvent/Octavius.pm';
author   'Pedro Melo <melo@cpan.org>';

build_requires 'Test::More';

auto_install;

WriteAll;

