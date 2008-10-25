use inc::Module::Install;

name     'App-Octavius-Tracker';
all_from 'lib/App/Octavius/Tracker.pm';

install_script 'octavius-tracker';

requires 'AnyEvent'             => 0;
requires 'Mojo'                 => 0;
requires 'AnyEvent::Mojo'       => 0;
requires 'AnyEvent::Socket'     => 0;
requires 'AnyEvent::Handle'     => 0;
requires 'IO::Socket::INET'     => 0;

build_requires 'Test::More';

WriteAll;

