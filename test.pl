#!/usr/bin/perl

use 5.006;
use Test2::V0;
use warnings FATAL => 'all';
use Carp::Always;


use Syntax::Feature::TrVars;
    
my $search = '/+=';
my $replace = '-_';
my $s = 'De/0xv5y3w8BpLF8ubOo+w==';
ok trvars {eval '$s =~ tr/$search/$replace/d; 1'}, 'runs', $@;
is $s, 'De-0xv5y3w8BpLF8ubOo_w', 'modified', $@;

done_testing;
