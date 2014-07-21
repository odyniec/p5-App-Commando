package App::Commando::Option;

use strict;
use warnings;

use Moo;

has 'description' => ( is => 'ro' );

has 'long' => ( is => 'ro' );

has 'short' => ( is => 'ro' );

sub BUILDARGS {
    my ($class, $config_key, $info) = @_;

    my $buildargs = {};

    for my $arg (@$info) {
        if ($arg =~ /^-/) {
            if ($arg =~ /^--/) {
                $buildargs->{long} = $arg;
            }
            else {
                $buildargs->{short} = $arg;
            }
        }
        else {
            $buildargs->{description} = $arg;
        }
    }

    return $buildargs;
}

1;
