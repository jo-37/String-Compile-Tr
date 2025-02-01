#!perl -T

use Test2::Require::Perl 'v5.10';
use 5.010;
use Test2::V0;

use Syntax::Feature::TrVars;

sub test_state {
    my $arg = shift;
    state $state;
    if ($arg) {
        $state = 'b';
        pass 'init';
        return;
    }
    my $s = 'ab';
    ok trvars {eval '$s =~ tr/$state/X/; 1'}, 'run state', $@;
    is $s, 'aX', 'use state';
}
test_state(-dummy);
test_state();


done_testing;

