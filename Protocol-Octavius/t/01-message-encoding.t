#! perl

use strict;
use warnings;
use Test::More 'no_plan';

use Protocol::Octavius::Message;

my @msgs_tests = (
  [ [ 1            ] => "\x00\x00\x00\x04\x00\x01\x01\x00" ],
  [ [ 2, 'a'       ] => "\x00\x00\x00\x06\x00\x02\x02\x01a\x00" ],
  [ [ 4, 'a', 'bb' ] => "\x00\x00\x00\x09\x00\x03\x04\x02a\x00bb\x00" ],
);

my $expected_id = 1;
foreach my $test (@msgs_tests) {
  my ($args, $result) = @$test;
  my ($msg, $id) = Protocol::Octavius::Message::_encode(@$args);
  is($msg, $result, "encode correct for ID $expected_id ".length($msg).' '.length($result));
  is($id, $expected_id++, 'proper id');
}

my ($len, $id, $type, @attrs) = Protocol::Octavius::Message::parse_mesg(
  "\x00\x00\x00\x09\x00\x03\x04\x02a\x00bb\x00"
);
is($len, 13);
is($id, 3);
is($type, 4);
is($attrs[0], 'a');
is($attrs[1], 'bb');
