package App::Commando::Program;

use strict;
use warnings;

use Moo;

extends 'App::Commando::Command';

has 'config' => ( is => 'ro' );

around BUILDARGS => sub {
    my ($orig, $self, $name) = @_;

    return {
        config => {},
        %{$self->$orig($name)}
    };
};

around go => sub {
    my ($orig, $self, $argv) = @_;

    $self->$orig($argv, $self->config);
};

1;
