package App::Commando::Presenter;

use strict;
use warnings;

use Moo;

has 'command' => ( is => 'rw' );

sub BUILDARGS {
    my ($class, $command) = @_;

    return {
        command => $command,
    };
}

1;
