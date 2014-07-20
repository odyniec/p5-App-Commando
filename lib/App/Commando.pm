package App::Commando;

use strict;
use warnings;

# ABSTRACT: Flexible library to build command-line apps

# VERSION

use App::Commando::Program;

sub program {
    my ($name) = @_;

    my $program = App::Commando::Program->new($name);

    return $program;
}

1;
