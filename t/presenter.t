use strict;
use warnings;

use Test::More;

use App::Commando::Command;

BEGIN { use_ok('App::Commando::Presenter'); }

my $command = App::Commando::Command->new('foo');
my $subcommand = App::Commando::Command->new('bar', $command);
$subcommand->version('0.4.2');
$subcommand->option('one', '-1', '--one', 'First option');
$subcommand->option('two', '-2', '--two', 'Second option');
$subcommand->alias('baz');

my $presenter = App::Commando::Presenter->new($subcommand);
isa_ok $presenter, 'App::Commando::Presenter', '$presenter';

is($presenter->command_presentation,
'foo bar 0.4.2

Usage:

  foo bar

Options:
        -1, --one          First option
        -2, --two          Second option',
'command_presentation has the expected content');

done_testing;
