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

sub default_command {
    my ($self, $command_name) = @_;

    if ($command_name) {
        if (exists $self->commands->{$command_name}) {
            return $self->{_default_command} = $self->commands->{$command_name};
        }
        else {
            # TODO: Error
        }
    }
    else {
        return $self->{_default_command};
    }
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

    if (defined $argv->[0] && exists $self->commands->{$argv->[0]}) {
        my $cmd = $self->commands->{$argv->[0]};
        shift @$argv;
        $cmd->go($argv, $config);
    }
    else {
        return $self;
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

    Getopt::Long::Configure('pass_through');
    GetOptions(%options_spec);
}

sub execute {
    my ($self, $argv, $config) = @_;

    $argv //= [];
    $config //= {};

    if (!@{$self->actions} && defined $self->default_command) {
        $self->default_command->execute;
    }
    else {
        for my $action (@{$self->actions}) {
            &$action($argv, $config);
        }
    }
}

1;
