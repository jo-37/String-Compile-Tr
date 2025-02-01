#!perl -T

use 5.006;
use Test2::V0;

use String::Compile::Tr;

{
    my $x = 'abc';
    my $y = '123';

    my $s = 'edcba';
    my $tr = trgen($x, $y);
    ref_ok $tr, 'CODE', 'is a sub';
    ok lives {$tr->($s)}, 'call';
    is $s, 'ed321', '$s changed';
}

{
    my $x = 'abc';
    my $y = '123';
    is trgen('abc', '123', 'r')->('edcba'), 'ed321', 'use options';
}

{
    my $tr = trgen('abc', 'ABC');
    my @arr = qw(axy bxy cxy);
    $tr->() for @arr;
    is [@arr], [qw(Axy Bxy Cxy)], 'multiple calls on $_';
}

done_testing;

