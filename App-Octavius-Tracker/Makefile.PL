use inc::Module::Install;

name     'App-Octavius-Tracker';
all_from 'lib/App/Octavius/Tracker.pm';
author   'Pedro Melo <melo@cpan.org>';

build_requires 'Test::More';

auto_install;

WriteAll;

