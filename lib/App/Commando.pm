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

__END__

=head1 SYNOPSIS

    use App::Commando;

    my $program = App::Commando::program('example');
    $program->version('0.42');

    my $cmd_hello = $program->command('hello');
    $cmd_hello->syntax('hello TARGET');
    $cmd_hello->option('world', '-w', '--world', 'Say hello to the World');
    $cmd_hello->option('universe', '-u', '--universe', 'Say hello to the Universe');
    $cmd_hello->action(sub {
        my ($argv, $config) = @_;

        # Get the first argument or set the default value
        my $target = $argv->[0] || 'Everyone';
        $target = "World" if $config->{world};
        $target = "Universe" if $config->{universe};

        print "Hello, $target!\n";
    });

    my $cmd_bye = $program->command('bye');
    $cmd_bye->action(sub {
        print "Goodbye!\n";
    });

    $program->go;
