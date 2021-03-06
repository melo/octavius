package App::Octavius::Tracker;

use warnings;
use strict;
use base 'Mojo::Base';
use AnyEvent;
use AnyEvent::Socket;
use Getopt::Long;
use IO::Socket::INET qw( SOMAXCONN );

use App::Octavius::Tracker::AgentConnection;

our $VERSION = '0.01';

__PACKAGE__->attr('agents_port', chained => 1, default => 4920);
__PACKAGE__->attr('agents_host', chained => 1);
__PACKAGE__->attr('agents_listen_queue',
  chained => 1,
  default => sub { SOMAXCONN },
);

__PACKAGE__->attr('agent_connection_class',
  chained => 1,
  default => 'App::Octavius::Tracker::AgentConnection',
);

__PACKAGE__->attr('tracker_guard', chained => 1);
__PACKAGE__->attr('agents_port_guard', chained => 1);


#######################
# Peer listening socket

sub start_agents_port {
  my $self = shift;
  
  # Already listening
  return if $self->agents_port_guard;
  
  my $guard = tcp_server($self->agents_host, $self->agents_port,
    # on connection
    sub {
      my ($sock, $peer_host, $peer_port) = @_;
      
      if (!$sock) {
        $self->log("Connect failed: $!");
        return;
      }
      
      $self->agent_connection_class->new(
        tracker   => $self,
        sock      => $sock,
        peer_host => $peer_host,
        peer_port => $peer_port,
      )->start;
    },
    
    # Setup listen queue size, record our hostname and port
    sub {
      $self->agents_host($_[1])->agents_port($_[2]);
      
      return $self->agents_listen_queue;
    }
  );
  
  $self->agents_port_guard(sub { $guard = undef });
  $self->startup_banner;
  
  return;
}

sub stop_agents_port {
  my $self = shift;
  
  my $g = $self->agents_port_guard;
  $g->() if $g;
  
  return;
}

sub startup_banner {
  my $self = shift;
  my $host = $self->agents_host;
  my $port = $self->agents_port;
  
  $self->log("Ready for agents at $host:$port");
}


#############################
# Manage the tracker lifetime

sub start {
  my $self = shift;
  
  $SIG{PIPE} = 'IGNORE';
  
  $self->start_agents_port;
  
  my $guard = AnyEvent->condvar;
  $self->tracker_guard(sub { $guard->send });
  
  $guard->recv;
}

sub stop {
  my $self = shift;
  
  $self->stop_agents_port;

  my $g = $self->tracker_guard;
  $g->() if $g;
  
  return;
}


######################
# Command line options

sub parse_options {
  my $self = shift;

  my $ok = GetOptions(
    'agents-port=i'         => sub { $self->agents_port($_[1]) },
    'agents-host=s'         => sub { $self->agents_host($_[1]) },
    'agents-listen-queue=i' => sub { $self->agents_listen_queue($_[1]) },
  );
  
  $self->usage unless $ok;
  
  return;
}

sub usage {
  print STDERR <<"  USAGE";

Usage: $0 OPTIONS

  Options can be:
  
    --agents-host           IP to bind the tracker to
                            (default: all interfaces)
    --agents-port           TCP port to use (default: 4920)
    --agents-listen-queue   Tweak the number of pending agents to accept

  USAGE
  exit(1);
}


########
# Logger

sub log {
  my $self = shift;
  my $time = localtime();
  warn "[$time] [$$] ".join('', @_)."\n";
}


42; # End of App::Octavius::Tracker

__END__

=encoding utf8

=head1 NAME

App::Octavius::Tracker - A tracker for an Octavius cloud


=head1 VERSION

Version 0.01


=head1 SYNOPSIS

    use App::Octavius::Tracker;

    my $foo = App::Octavius::Tracker->new();
    ...


=head1 AUTHOR

Pedro Melo, C<< <melo at cpan.org> >>


=head1 BUGS

Please report any bugs or feature requests to C<bug-app-octavius-tracker at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Octavius-Tracker>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::Octavius::Tracker


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Octavius-Tracker>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-Octavius-Tracker>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-Octavius-Tracker>

=item * Search CPAN

L<http://search.cpan.org/dist/App-Octavius-Tracker>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Pedro Melo,.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

