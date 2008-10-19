#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'App::Octavius::Tracker' );
}

diag( "Testing App::Octavius::Tracker $App::Octavius::Tracker::VERSION, Perl $], $^X" );
