#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'AnyEvent::Octavius' );
}

diag( "Testing AnyEvent::Octavius $AnyEvent::Octavius::VERSION, Perl $], $^X" );
