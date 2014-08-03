use strict;
use warnings;

use Test::Fatal;
use Test::More;

BEGIN { use_ok('App::Commando::Program'); }

my $program = App::Commando::Program->new('foo');
isa_ok $program, 'App::Commando::Program', '$program';

done_testing;
