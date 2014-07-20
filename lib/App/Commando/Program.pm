package App::Commando::Program;

use strict;
use warnings;

use Moo;

extends 'App::Commando::Command';

sub BUILDARGS {
    my ($class, $name) = @_;

    return {
        'name' => $name,
    };
}

1;
