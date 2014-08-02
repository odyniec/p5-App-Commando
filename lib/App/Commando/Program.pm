package App::Commando::Program;

use strict;
use warnings;

use Getopt::Long qw( GetOptionsFromArray );
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

    if (!defined $argv) {
        $argv = \@ARGV;
    }

    my $cmd = $self->$orig($argv, $self->config);

    # Run through all options again in case there are any unknown ones
    Getopt::Long::Configure('no_pass_through');
    GetOptionsFromArray($argv,
        { map { $_->for_get_options => undef } @{$self->options} });

    $cmd->execute($argv, $self->config);
};

1;
