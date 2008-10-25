#! perl

use strict;
use warnings;
use Test::More tests => 3;
use App::Octavius::Tracker;

my $trk = App::Octavius::Tracker->new;
isa_ok($trk, 'App::Octavius::Tracker');
is($trk->peer_port, 4920);

# Pick @ARGV by default
{
  local @ARGV;
  
  @ARGV = ( '--peer-port', 1500 );
  $trk->parse_options;
  is($trk->peer_port, 1500);
}


