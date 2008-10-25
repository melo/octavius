#! perl

use strict;
use warnings;
use Test::More 'no_plan';

use Protocol::Octavius::MessageCoder;

my @msgs_tests = (
  [ [ 1            ] => "\x00\x00\x00\x04\x00\x01\x01\x00" ],
  [ [ 2, 'a'       ] => "\x00\x00\x00\x06\x00\x02\x02\x01a\x00" ],
  [ [ 4, 'a', 'bb' ] => "\x00\x00\x00\x09\x00\x03\x04\x02a\x00bb\x00" ],
);

my $expected_id = 1;
foreach my $test (@msgs_tests) {
  my ($args, $result) = @$test;
  my ($msg, $id) = Protocol::Octavius::MessageCoder::_encode(@$args);
  is($msg, $result, "encode correct for ID $expected_id ".length($msg).' '.length($result));
  is($id, $expected_id++, 'proper id');
}

my ($msg, $id) = Protocol::Octavius::MessageCoder::mk_id_mesg('my-name');
is(
  $msg,
  "\x00\x00\x00\x0C\x00\x04\x69\x01my-name\x00",
  'ID message is ok',
);
is($id, 4, 'proper ID');

($msg, $id) = Protocol::Octavius::MessageCoder::mk_id_ack_mesg('my-name');
is(
  $msg,
  "\x00\x00\x00\x0C\x00\x05\x49\x01my-name\x00",
  'ID Ack message is ok',
);
is($id, 5, 'proper ID');


# Parser

my $r = Protocol::Octavius::MessageCoder->parse_mesg(
  "\x00\x00\x00\x09\x00\x03\x04\x02a\x00bb\x00"
);
ok(ref($r));
my ($len, $rid, $type, @attrs) = @$r;
is($len, 13);
is($rid, 3);
is($type, 4);
is($attrs[0], 'a');
is($attrs[1], 'bb');

my %incomplete = (
  "\x00" => 4,
  "\x00\x00" => 4,
  "\x00\x00\x00" => 4,
  "\x00\x00\x00\x01" => 5,
  "\x00\x00\x00\x0A" => 14,
  "\x00\x00\x00\x0Ai" => 14,
  "\x00\x00\x00\x0Bi" => 15,
  "\x00\x00\x00\x09\x00\x03\x04\x02a\x00bb" => 13,
);

while (my ($try, $res) = each %incomplete) {
  my $ans = Protocol::Octavius::MessageCoder->parse_mesg($try);
  ok(!ref($ans));
  is($ans, $res, "for '".unpack("H*", $try)."' => $res");
}

