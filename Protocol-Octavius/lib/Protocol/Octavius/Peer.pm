package Protocol::Octavius::Peer;

use strict;
use warnings;
use base 'Protocol::Octavius::Base';
use Carp;

our $VERSION = '0.1';

__PACKAGE__->attr('pending', chained => 1, default => {});

#######################################
# Send message, keep track of callbacks

sub send {
  my ($self, $id, $mesg, $cb) = @_;
  my $pending = $self->{pending};
  
  my $guard; $guard = $self->_cb_in(2, sub {
    my $state = delete $pending->{$id};
    $cb->($self, $id, undef) if $state && $cb;
  });
  
  $pending->{$id} = {
    id => $id,
    cb => $cb,
    gr => $guard,
  };
  
  $self->_write($mesg);
  
  return $id;
}


####################################
# Receive message, take care of Acks

sub receive {
  my $self = shift;
  my ($id, $type, @attrs) = @_;
  
  if ($type eq 'A') { # Ack message
    my $state = delete $self->{pending}{$id};
    
    if (!$state) {
      $state->{cb}->($self, $id, $type, @attr) if $state->{cb};
    }
    else {
      $self->log("Got Ack for id $id without related pending state");
    }
    
    return;
  }

  # ... pass along to our tracker
  $self->log("Got message type $id '$type'");
  
  return;
}


###############
# Subclass this

sub log    { croak "Subclass $_[0] must declare log(), "    }
sub _write { croak "Subclass $_[0] must declare _write(), " }
sub _cb_in { croak "Subclass $_[0] must declare _cb_in(), " }

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
