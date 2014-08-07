use strict;
use warnings;

use Test::More;

use App::Commando;

my %tests = (
    'No arguments and no switches' => {
        ARGV            => [],
        expected_argv   => [],
        expected_config => {},
    },
    'One short switch' => {
        ARGV            => [ '-f' ],
        expected_argv   => [],
        expected_config => { 'foo' => '1' },
    },
    'One argument' => {
        ARGV            => [ 'xyzzy' ],
        expected_argv   => [ 'xyzzy' ],
        expected_config => {},
    },
);

for my $test_name (keys %tests) {
    local @ARGV = @{$tests{$test_name}->{ARGV}};

    my $program = App::Commando::program('test');
    $program->option('foo', '-f', '--foo', 'Enables foo');
    $program->option('bar', '-b', '--bar', 'Enables bar');
    $program->action(sub {
        my ($argv, $config) = @_;

        is_deeply $argv, $tests{$test_name}->{expected_argv},
            "$test_name: argv";
        is_deeply $config, $tests{$test_name}->{expected_config},
            "$test_name: config";
    });
    $program->go;
}

done_testing;
