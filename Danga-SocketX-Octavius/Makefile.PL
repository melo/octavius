use inc::Module::Install;

name     'Danga-SocketX-Octavius';
all_from 'lib/Danga/SocketX/Octavius.pm';
author   'Pedro Melo <melo@cpan.org>';

build_requires 'Test::More';

auto_install;

WriteAll;

