#!/usr/bin/perl

use 5.006;
use Test2::V0;
use warnings FATAL => 'all';
use Carp::Always;
use Data::Dump;

use String::Compile::Tr;
    
is trgen('/+=', '-_', 'dr')->('De/0xv5y3w8BpLF8ubOo+w=='),
    'De-0xv5y3w8BpLF8ubOo_w', 'modified';


my $search =  'abcdefghij';
my $replace = '0123456789';
my $str = 'ghijklmn';
ok my $tr = trgen($search, $replace), 'create tr';
ok lives {$tr->()}, 'run tr on $_' for $str;
is $str, '6789klmn', 'modify $str';

done_testing;
