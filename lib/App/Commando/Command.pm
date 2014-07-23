package App::Commando::Command;

use strict;
use warnings;

use Getopt::Long;
use Moo;

use App::Commando::Option;

has 'actions' => ( is => 'rw' );

has 'commands' => ( is => 'rw' );

has 'map' => ( is => 'ro' );

has 'name' => ( is => 'ro' );

has 'options' => ( is => 'rw' );

has 'parent' => ( is => 'rw' );

sub BUILDARGS {
    my ($class, $name, $parent) = @_;

    return {
        actions     => [],
        commands    => {},
        map         => {},
        name        => $name,
        options     => [],
        parent      => $parent,
    };
}

sub option {
    my ($self, $config_key, @info) = @_;

    my $option = App::Commando::Option->new($config_key, @info);
    push @{$self->options}, $option;
    $self->map->{$option} = $config_key;
}

sub command {
    my ($self, $cmd_name) = @_;

    my $cmd = App::Commando::Command->new($cmd_name, $self);
    $self->commands->{$cmd_name} = $cmd;

    return $cmd;
}

sub action {
    my ($self, $code) = @_;

    push @{$self->actions}, $code;
}

sub go {
    my ($self, $argv, $config) = @_;

    $self->process_options($config);

    if ($argv->[0] && exists $self->commands->{$argv->[0]}) {
        my $cmd = $self->commands->{$argv->[0]};
        shift @$argv;
        $cmd->go($argv, $config);
    }
}

sub process_options {
    my ($self, $config) = @_;

    my %options_spec = ();

    for my $option (@{$self->options}) {
        $options_spec{$option->for_get_options} = sub {
            my ($name, $value) = @_;
            $config->{$self->map->{$option}} = $value;
        };
    }

    GetOptions(%options_spec);
}

1;
