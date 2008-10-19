#! perl

use strict;
use warnings;
use Test::More 'no_plan';

use Protocol::Octavius::Message;

my @msgs_tests = (
  [ [ 1            ] => "\x00\x01\x01\x00" ],
  [ [ 2, 'a'       ] => "\x00\x02\x02\x01\x00\x01a" ],
  [ [ 4, 'a', 'bb' ] => "\x00\x03\x04\x02\x00\x01a\x00\x02bb" ],
);

my $expected_id = 1;
foreach my $test (@msgs_tests) {
  my ($args, $result) = @$test;
  my ($msg, $id) = Protocol::Octavius::Message::_encode(@$args);
  is($msg, $result);
  is($id, $expected_id++);
}

