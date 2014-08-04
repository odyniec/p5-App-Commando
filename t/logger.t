use strict;
use warnings;

use Test::Fatal;
use Test::More;

BEGIN { use_ok('App::Commando::Logger'); }

my $logger = App::Commando::Logger->new(*STDOUT);
isa_ok $logger, 'App::Commando::Logger', '$logger';

done_testing;
