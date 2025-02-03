#!/usr/bin/perl

use Test2::V0;
use warnings FATAL => 'all';
use Carp::Always;
use Regexp::Tr;

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
    my $str = join('', 'a' .. 'z') . '/,-$@=~';
    my $str1 = $str;
    my $str2 = $str;
    ok no_warnings {trgen($search, '', 'd')->($str)}, "not eval'ed";
    my $expected = 'bcfghijklmoqsuvxyz';
    is $str, $expected, 'deleted chars';

    like warning {eval "\$str1 =~ tr/$search//d"}, qr/-trapped/, 'eval trapped';

    my $todo = todo 'Regexp::Tr';
    my $tr = Regexp::Tr->new($search, '', 'd');
    ok no_warnings {$tr->bind(\$str2)}, "not eval'ed";
    is $str2, $expected, 'deleted chars';
    
}



done_testing;
