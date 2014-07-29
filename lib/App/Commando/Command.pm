package App::Commando::Command;

use strict;
use warnings;

use Getopt::Long;
use Moo;

use App::Commando::Logger;
use App::Commando::Option;

has 'actions' => ( is => 'rw' );

has 'aliases' => ( is => 'ro' );

has 'commands' => ( is => 'rw' );

has 'map' => ( is => 'ro' );

has 'name' => ( is => 'ro' );

has 'options' => ( is => 'rw' );

has 'parent' => ( is => 'rw' );

sub BUILDARGS {
    my ($class, $name, $parent) = @_;

    return {
        actions     => [],
        aliases     => [],
        commands    => {},
        map         => {},
        name        => $name,
        options     => [],
        parent      => $parent,
    };
}

# Gets or sets the command version
sub version {
    my ($self, $version) = @_;

    $self->{_version} = $version if defined $version;
    return $self->{_version};
}

sub syntax {
    my ($self, $syntax) = @_;

    $self->{_syntax} = $syntax if defined $syntax;

    my @syntax_list = ();

    if ($self->parent) {
        my $parent_syntax = $self->parent->syntax;
        $parent_syntax =~ s/<[\w\s-]+>|\[[\w\s-]+\]//g;
        $parent_syntax =~ s/^\s+|\s+$//g;
        push @syntax_list, $parent_syntax;
    }
    push @syntax_list, ($self->{_syntax} || $self->name);

    return join ' ', @syntax_list;
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

sub alias {
    my ($self, $cmd_name) = @_;

    push @{$self->aliases}, $cmd_name;
    $self->parent->commands->{$cmd_name} = $self
        if $self->parent;
}

sub action {
    my ($self, $code) = @_;

    push @{$self->actions}, $code;
}

sub logger {
    my ($self) = @_;

    unless ($self->{_logger}) {
        $self->{_logger} = App::Commando::Logger->new;
    }

    return $self->{_logger};
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
