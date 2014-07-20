package App::Commando::Program;

use strict;
use warnings;

use Moo;

extends 'App::Commando::Command';

around BUILDARGS => sub {
    my ($orig, $self, $name) = @_;

    return $self->$orig($name);
};

1;
