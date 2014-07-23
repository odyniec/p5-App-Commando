package App::Commando::Option;

use strict;
use warnings;

use Moo;

has 'description' => ( is => 'ro' );

has 'long' => ( is => 'ro' );

has 'short' => ( is => 'ro' );

has 'spec' => ( is => 'ro' );

sub BUILDARGS {
    my ($class, $config_key, @info) = @_;

    my $buildargs = {};

    # Getopt::Long regular expression to match argument specification
    my $spec_re = qr(
        # Either modifiers ...
        [!+]
        |
        # ... or a value/dest/repeat specification
        [=:] [ionfs] [@%]? (?: \{\d*,?\d*\} )?
        |
        # ... or an optional-with-default spec
        : (?: -?\d+ | \+ ) [@%]?
    )x;

    for my $arg (@info) {
        if ($arg =~ /^-/) {
            if ($arg =~ /^--/) {
                $buildargs->{long} = $arg;
            }
            else {
                $buildargs->{short} = $arg;
            }
        }
        elsif ($arg =~ $spec_re) {
            $buildargs->{spec} = $arg;
        }
        else {
            $buildargs->{description} = $arg;
        }
    }

    return $buildargs;
}

sub for_get_options {
    my ($self) = @_;

    return
        join('|',
            grep { /\S/ } # Exclude empty strings
                map { s/^-+//; $_ } # Strip off leading dashes
                    map { $self->$_ } qw( short long )) .
        $self->spec;
}

1;
