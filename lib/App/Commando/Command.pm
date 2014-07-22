package App::Commando::Command;

use strict;
use warnings;

use Moo;

has 'commands' => ( is => 'rw' );

has 'name' => ( is => 'ro' );

has 'options' => ( is => 'rw' );

has 'parent' => ( is => 'rw' );

sub BUILDARGS {
    my ($class, $name, $parent) = @_;

    return {
        commands    => {},
        name        => $name,
        options     => [],
        parent      => $parent,
    };
}

sub option {
    my ($self, $config_key, @info) = @_;

    my $option = App::Commando::Option->new($config_key, @info);
    push @{$self->options}, $option;
}

sub command {
    my ($self, $cmd_name) = @_;

    my $cmd = App::Commando::Command->new($cmd_name, $self);
    $self->commands->{$cmd_name} = $cmd;

    return $cmd;
}

1;
