use strict;
use warnings;

use Test::More;

use App::Commando::Command;

BEGIN { use_ok('App::Commando::Presenter'); }

my $command = App::Commando::Command->new('foo');
my $subcommand = App::Commando::Command->new('bar', $command);

my $presenter = App::Commando::Presenter->new($command);
isa_ok $presenter, 'App::Commando::Presenter', '$presenter';

done_testing;
