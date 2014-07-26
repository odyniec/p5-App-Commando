use strict;
use warnings;

use Test::More;

BEGIN { use_ok('App::Commando::Command'); }

my $command = App::Commando::Command->new;
isa_ok $command, 'App::Commando::Command', '$command';

done_testing;
