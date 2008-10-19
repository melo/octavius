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

my ($msg, $id) = Protocol::Octavius::Message::mk_id_mesg('my-name');
is(
  $msg,
  "\x00\x00\x00\x0C\x00\x04\x69\x01my-name\x00",
  'ID message is ok',
);
is($id, 4, 'proper ID');

($msg, $id) = Protocol::Octavius::Message::mk_id_ack_mesg('my-name');
is(
  $msg,
  "\x00\x00\x00\x0C\x00\x05\x49\x01my-name\x00",
  'ID Ack message is ok',
);
is($id, 5, 'proper ID');


# Parser

my ($len, $rid, $type, @attrs) = Protocol::Octavius::Message::parse_mesg(
  "\x00\x00\x00\x09\x00\x03\x04\x02a\x00bb\x00"
);
is($len, 13);
is($rid, 3);
is($type, 4);
is($attrs[0], 'a');
is($attrs[1], 'bb');
