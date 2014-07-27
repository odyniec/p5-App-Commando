use strict;
use warnings;

use Test::More;

BEGIN { use_ok('App::Commando::Command'); }

my $command = App::Commando::Command->new('foo');
isa_ok $command, 'App::Commando::Command', '$command';

is $command->version, undef, 'Version is undefined as expected';
is $command->version('1.2.3'), '1.2.3',
    'Version is returned correctly when being set';
is $command->version, '1.2.3', 'Version is correct after setting';

is $command->syntax, 'foo', 'Syntax is initially the same as command name';
is $command->syntax('foo [options]'), 'foo [options]',
    'Syntax is returned correctly when being set';
is $command->syntax, 'foo [options]', 'Syntax is correct after setting';

done_testing;
