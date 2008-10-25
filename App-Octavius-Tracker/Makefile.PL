use inc::Module::Install;

name     'App-Octavius-Tracker';
all_from 'lib/App/Octavius/Tracker.pm';

requires 'AnyEvent'             => 0;
requires 'Mojo'                 => 0;
requires 'AnyEvent::Mojo'       => 0;
requires 'AnyEvent::Socket'     => 0;
requires 'IO::Socket::INET'     => 0;

build_requires 'Test::More';

WriteAll;

