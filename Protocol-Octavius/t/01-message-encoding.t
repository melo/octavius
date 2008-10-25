#! perl

use strict;
use warnings;
use Test::More 'no_plan';
use Protocol::Octavius::MessageCoder qw(:coders);


### Encoder / Decoder

my @msgs_tests = (
  [ [ undef, 1            ] => "\x00\x00\x00\x04\x00\x01\x01\x00" ],
  [ [ undef, 2, 'a'       ] => "\x00\x00\x00\x06\x00\x02\x02\x01a\x00" ],
  [ [ undef, 4, 'a', 'bb' ] => "\x00\x00\x00\x09\x00\x03\x04\x02a\x00bb\x00" ],
);

my $expected_id = 1;
foreach my $test (@msgs_tests) {
  my ($args, $result) = @$test;
  my ($msg, $id) = msg_encoder(@$args);
  is($msg, $result, "encode correct for ID $expected_id ".length($msg).' '.length($result));
  is($id, $expected_id++, 'proper id');
  
  my $dec = msg_decoder($msg);
  ok(ref($dec), 'decoded correctly');
  is($dec->[0], length($msg), 'length matches expected');
  is($dec->[1], $id, "correct ID $id");

  my $d = 0;  
  foreach my $v (@$args) {
    is($dec->[1+$d], $v, "Pos $d should be '$v'") if defined $v;
    $d++;
  }
}


### Decoder - full message

my $r = msg_decoder("\x00\x00\x00\x09\x00\x03\x04\x02a\x00bb\x00");
ok(ref($r));
my ($len, $rid, $type, @attrs) = @$r;
is($len, 13);
is($rid, 3);
is($type, 4);
is($attrs[0], 'a');
is($attrs[1], 'bb');


### Decoder - incomplete messages

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
  my $ans = msg_decoder($try);
  ok(!ref($ans));
  is($ans, $res, "for '".unpack("H*", $try)."' => $res");
}

