package App::Commando::Logger;

use strict;
use warnings;

use Moo;

sub _store {
    my ($self, $level, $message) = @_;

    print STDERR $message;
}

sub debug {
    my ($self, $message) = @_;

    $self->_store('debug', $message);
}

sub info {
    my ($self, $message) = @_;

    $self->_store('info', $message);
}

sub warn {
    my ($self, $message) = @_;

    $self->_store('warn', $message);
}

sub error {
    my ($self, $message) = @_;

    $self->_store('error', $message);
}

sub fatal {
    my ($self, $message) = @_;

    $self->_store('fatal', $message);
}

1;
