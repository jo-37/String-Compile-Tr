#!perl -T

use 5.006;
use Test2::V0;

use Syntax::Feature::TrVars;

{
    my $x = 'abc';
    my $y = '123';

    my $s = 'edcba';
    ok lives {eval '$s =~ tr/$x/$y/; 1' or die $@}, 'no error, lexical', $@;
    is $s, 'ed321', '$s changed';

    like dies {eval '$s =~ tr/$x/$z/; 1' or die $@}, qr/not defined/,
        '$z not defined';
}

{
    our $o = 'def';
    my $s = 'bcde';
    ok lives {eval '$s =~ tr/$o/456/; 1' or die $@}, 'no error, dynamic', $@;
    is $s, 'bc45', '$s changed';
}

{
    my $t = substr $ENV{PATH}, 0, 0;
    my $s = 'defg';
    ok lives {eval '$s =~ tr/$t//; 1' or die $@},
        'tainted operand accepted', $@;
}

{
    our $glob = 'a';
    {
        local $glob = 'b';
        my $s = 'ab';
        ok lives {eval '$s =~ tr/$glob/X/; 1' or die $@},
            'run local', $@;
        is $s, 'aX', 'use local';
    }
}

{
    our $pre;
    BEGIN {
        $pre = 'bcd';
    }
    my $s = 'edcba';
    $s =~ tr/$pre/456/;
    is $s, 'e654a', 'compile time usage';
}

### ToDo
{
    my $todo = todo 'probably a bug in PadWalker';
    my $b52 = 'a';
    my $s = 'ab';
    ok lives {eval '$s =~ tr/$b52/X/; 1' or die $@},
        'run b52', $@;
}
{
    # The declaration of $b52 in a different scope causes the previous
    # test to fail.
    # B52's are long-range, but F16 would fail here, too.
    my $b52 = 'b';
}
###

{
    no Syntax::Feature::TrVars;

    my $s = 'cba$';
    my $abc = 'cba$';
    is $s =~ tr/$abc/@123/r, '321@', 'disabled';
}

done_testing;

