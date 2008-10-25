package App::Octavius::Tracker::AgentConnection;

use warnings;
use strict;
use base 'Mojo::Base';
use AnyEvent::Handle;

our $VERSION = '0.01';

__PACKAGE__->attr('peer_host', chained => 1);
__PACKAGE__->attr('peer_port', chained => 1);
__PACKAGE__->attr('sock',      chained => 1);
__PACKAGE__->attr('tracker',   chained => 1);

__PACKAGE__->attr('handle', chained => 1);


###################
# Start the reading

sub start {
  my $self = shift;
  
  my $handle = AnyEvent::Handle->new(
    fh         => $self->sock,
    timeout    => 5,
    on_eof     => sub { $self->stop('eof')     },
    on_error   => sub { $self->stop('error')   },
    on_timeout => sub { $self->stop('timeout') },
  );
  $self->handle($handle);
  
  return;
}

sub stop {
  my $self = shift;
  
  $self->handle(undef);
  close($self->sock);
}


########
# Logger

sub log {
  my $self = shift;
  
  return $self->tracker->log(@_);
}


42; # End of App::Octavius::Tracker::AgentConnection

__END__

=encoding utf8

=head1 NAME

App::Octavius::Tracker::AgentConnection - Agent connections to the tracker


=head1 VERSION

Version 0.01


=head1 SYNOPSIS



=head1 AUTHOR

Pedro Melo, C<< <melo at cpan.org> >>


=head1 COPYRIGHT & LICENSE

Copyright 2008 Pedro Melo,.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

