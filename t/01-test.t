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
    our $pre;
    BEGIN {
        $pre = 'bcd';
    }
    my $s = 'edcba';
    $s =~ tr/$pre/456/;
    is $s, 'e654a', 'compile time usage';
}

{
    no Syntax::Feature::TrVars;

    my $s = 'cba$';
    my $abc = 'cba$';
    is $s =~ tr/$abc/@123/r, '321@', 'disabled';
}

done_testing;

