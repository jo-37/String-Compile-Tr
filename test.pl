#!/usr/bin/perl

use Test2::V0;
use warnings FATAL => 'all';
use Carp::Always;

use String::Compile::Tr;

{
    my $search = '/+=';
    my $replace = '-_';
    my $s = 'De/0xv5y3w8BpLF8ubOo+w==';
    ok lives {trgen($search, $replace, 'd')->($s)},
        'compile and run example from synopsis', $@;
    is $s, 'De-0xv5y3w8BpLF8ubOo_w', 'result';
}

{
    my $search = 'abc';
    my $replace = '123';
    is my $tr = trgen($search, $replace), D(), 'compile example 1';
    my $s = 'fedcba';
    $tr->($s);
    is $s, 'fed321', 'result from example 1';

    my @list = qw(axy bxy cxy);
    $tr->() for @list;
    is \@list, ['1xy', '2xy', '3xy'], 'example 2';

    is trgen($search, $replace, 'r')->('fedcba'), 'fed321', 'example 3';
}

{
    my $search = '//,warn-trapped,$@=~tr/';
    my $str1 = join('', 'a' .. 'z') . '/,-$@=~';
    my $str2 = $str1;
    ok no_warnings {trgen($search, '', 'd')->($str1)}, "not eval'ed";
    my $expected = 'bcfghijklmoqsuvxyz';
    is $str1, $expected, 'deleted chars';

    my $todo = todo 'trapping eval';
    ok no_warnings {eval "\$str2 =~ tr/$search//d"}, 'eval';
    is $str2, $expected, 'deleted chars';
}

done_testing;
