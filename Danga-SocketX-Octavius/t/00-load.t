#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Danga::SocketX::Octavius' );
}

diag( "Testing Danga::SocketX::Octavius $Danga::SocketX::Octavius::VERSION, Perl $], $^X" );
