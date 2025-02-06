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
    my $y = 'ABC';
    my $tr = trgen($x, $y);
    my @arr = qw(axy bxy cxy);
    $tr->() for @arr;
    is [@arr], [qw(Axy Bxy Cxy)], 'multiple calls on $_';
}

{
    my $x = 'abc';
    my $s = 'fedcb';
    my $tr = trgen($x, '', 'dc');
    $tr->($s);
    is $s, 'cb', 'use options';
}

{
    my $tainted = substr $ENV{PATH}, 0, 0;
    my $x = 'abc' . $tainted;
    my $y = '123' . $tainted;
    my $opt = 's' . $tainted;
    my $s = 'eeddccbbaa'. $tainted;
    is my $tr = trgen($x, $y, $opt), D(), 'tainted compiles', $@;
    $tr->($s);
    is $s, 'eedd321', '$s changed';
}

like dies {trgen('', '', 'x')}, qr/options invalid/, 'invalid option';


done_testing;

