package Protocol::Octavius::Message;

use strict;
use warnings;

our $VERSION = '0.1';

my $next_message_id = 1;

sub _encode {
  my ($type, @attrs) = @_;
  my $n_attrs = @attrs;
  
  my $id = $next_message_id++;
  my $tmpl = 'nCC' . ('Z*' x $n_attrs);  
  my $header = pack($tmpl, $id, $type, $n_attrs, @attrs);
  
  return (pack('N', length($header)).$header, $id);
}

############
# ID message

sub mk_id_mesg {
  my ($id) = @_;
  
  return _encode(ord('i'), $id);
}

sub mk_id_ack_mesg {
  my ($id_ack) = @_;
  
  return _encode(ord('I'), $id_ack);
}


################
# Message parser

sub parse_mesg {
  my ($message) = @_;

  return unless length($message) >= 4;

  my $header_len = unpack('N', $message) + 4;
  return unless length($message) >= $header_len;
  
  my ($id, $type, $n_attr) = unpack('x4nCC', $message);
  
  my @attrs;
  my $tmpl = 'Z*' x $n_attr;
  @attrs = unpack('x8'.$tmpl, $message);
  
  return ($header_len, $id, $type, @attrs);
}

42; # End of X

__END__

=encoding utf8

=head1 NAME

Protocol::Octavius::Message - Encoder/decoder of Octavius messages



=head1 VERSION

Version 0.1



=head1 SYNOPSIS

    use Protocol::Octavius::Message;

    ...


=head1 DESCRIPTION



=head1 AUTHOR

Pedro Melo, C<< <melo at evolui.com> >>



=head1 COPYRIGHT & LICENSE

Copyright 2008 EVOLUI.COM.
