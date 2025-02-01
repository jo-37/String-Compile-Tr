#!perl -T

use 5.006;
use Test2::V0;

use Syntax::Feature::TrVars;

{
    my $x = 'abc';
    my $y = '123';

    my $s = 'edcba';
    ok trvars {eval '$s =~ tr/$x/$y/; 1'}, 'no error, lexical', $@;
    is $s, 'ed321', '$s changed';

    ok !trvars {eval '$s =~ tr/$x/$z/; 1'}, '$z not defined: not run',
    like $@, qr/not defined/, '$z not defined: error msg';
}

{
    our $o = 'def';
    my $s = 'bcde';
    ok trvars {eval '$s =~ tr/$o/456/; 1'}, 'no error, dynamic', $@;
    is $s, 'bc45', '$s changed';
}

{
    my $t = substr $ENV{PATH}, 0, 0;
    my $s = 'defg';
    ok trvars {eval '$s =~ tr/$t//; 1'}, 'tainted operand accepted', $@;
}

{
    our $glob = 'a';
    {
        local $glob = 'b';
        my $s = 'ab';
        ok trvars {eval '$s =~ tr/$glob/X/; 1'}, 'run local', $@;
        is $s, 'aX', 'use local';
    }
}

{
    my $todo = todo 'compile time usage';
    our $pre;
    BEGIN {
        $pre = 'bcd';
    }
    my $s = 'edcba';
    ok trvars {eval {$s =~ tr/$pre/456/; 1}}, 'run compile time';
    is $s, 'e654a', 'compile time usage';
}

{
#    my $todo = todo 'bug in PadWalker?';
    my $b52 = 'a';
    my $s = 'ab';
    ok trvars {eval '$s =~ tr/$b52/X/; 1'}, 'run b52', $@;
    is $s, 'Xb', 'modified b52';
}
{
    # The declaration of $b52 in any (?) scope after the previous block
    # caused the test therein to fail.
    my $b52 = 'b';
}

{
    no Syntax::Feature::TrVars;

    my $s = 'cba$';
    my $abc = 'cba$';
    is $s =~ tr/$abc/@123/r, '321@', 'disabled';
}

done_testing;

