use strict;
use warnings;

use Test::More;

BEGIN { use_ok('App::Commando::Option'); }

my $option = App::Commando::Option->new;
isa_ok $option, 'App::Commando::Option', '$option';

$option = App::Commando::Option->new('foo', '-f', '--foo', '=s', 'Foo');
is $option->description, 'Foo', 'Description is correct';
is $option->long, '--foo', 'Long switch is correct';
is $option->short, '-f', 'Short switch is correct';
is $option->spec, '=s', 'Spec is correct';

my $option2 = App::Commando::Option->new('foo', 'Foo', '=s', '--foo', '-f');
is_deeply $option2, $option, 'Order of constructor arguments doesn\'t matter';

is $option->for_get_options, 'f|foo=s', 'for_get_options is correct';

done_testing;
