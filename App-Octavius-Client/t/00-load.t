#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'App::Octavius::Client' );
}

diag( "Testing App::Octavius::Client $App::Octavius::Client::VERSION, Perl $], $^X" );
