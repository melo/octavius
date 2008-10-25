#! perl

use strict;
use warnings;
use Test::More tests => 5;
use App::Octavius::Tracker;

my $trk = App::Octavius::Tracker->new;
isa_ok($trk, 'App::Octavius::Tracker');
is($trk->agents_port, 4920);

# Pick @ARGV by default
{
  local @ARGV;
  
  @ARGV = (
    '--agents-port', 1500,
    '--agents-host', '127.0.0.1',
    '--agents-listen-queue', 20,
  );
  $trk->parse_options;
  is($trk->agents_port, 1500);
  is($trk->agents_host, '127.0.0.1');
  is($trk->agents_listen_queue, 20);
}


