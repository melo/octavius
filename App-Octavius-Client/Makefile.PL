use inc::Module::Install;

name     'App-Octavius-Client';
all_from 'lib/App/Octavius/Client.pm';
author   'Pedro Melo <melo@cpan.org>';

build_requires 'Test::More';

auto_install;

WriteAll;

