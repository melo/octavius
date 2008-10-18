#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Protocol::Octavius' );
}

diag( "Testing Protocol::Octavius $Protocol::Octavius::VERSION, Perl $], $^X" );
