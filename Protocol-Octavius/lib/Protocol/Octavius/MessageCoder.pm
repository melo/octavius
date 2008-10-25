package Protocol::Octavius::MessageCoder;

use strict;
use warnings;
use base qw( Exporter );


our $VERSION = '0.1';


#################
# Message encoder

my $next_message_id = 1;

sub msg_encoder {
  my ($id, $type, @attrs) = @_;
  my $n_attrs = @attrs;
  
  $id = $next_message_id++ unless defined $id;
  my $tmpl = 'nCC' . ('Z*' x $n_attrs);  
  my $header = pack($tmpl, $id, $type, $n_attrs, @attrs);
  
  return ($id, pack('N', length($header)).$header);
}


################
# Message decoder

sub msg_decoder {
  my ($message) = @_;

  return 4 unless length($message) >= 4;

  my $header_len = unpack('N', $message) + 4;
  return $header_len unless length($message) >= $header_len;
  
  my ($id, $type, $n_attr) = unpack('x4nCC', $message);
  
  my @attrs;
  my $tmpl = 'Z*' x $n_attr;
  @attrs = unpack('x8'.$tmpl, $message);
  
  return [ $header_len, $id, $type, @attrs ];
}


########################
# Exporter configuration

@Protocol::Octavius::MessageCoder::EXPORT = qw();
%Protocol::Octavius::MessageCoder::EXPORT_TAGS = (
    coders => [ qw( msg_encoder msg_decoder ) ],
);
@Protocol::Octavius::MessageCoder::EXPORT_OK = (
    (map { @$_} values %Protocol::Octavius::MessageCoder::EXPORT_TAGS)
);
$Protocol::Octavius::MessageCoder::EXPORT_TAGS{all} = [ @Protocol::Octavius::MessageCoder::EXPORT_OK ];


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
