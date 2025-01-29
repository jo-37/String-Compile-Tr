#!/usr/bin/perl

use 5.006;
use Test2::V0;
use warnings FATAL => 'all';
use Carp::Always;


use Syntax::Feature::TrVars;
    
my $search = '/+=';
my $replace = '-_';
my $s = 'De/0xv5y3w8BpLF8ubOo+w==';
ok lives {eval '$s =~ tr/$search/$replace/d; 1' or die $@}, 'runs', $@;
is $s, 'De-0xv5y3w8BpLF8ubOo_w', 'modified', $@;

our $pre;
BEGIN {
    $pre = 'abc';
}
$s = 'edcba';
$s =~ tr/$pre/123/;
is $s, 'ed321', 'compile time';

no Syntax::Feature::TrVars;

$s = 'cba$';
$s =~ tr/$abc/@123/;
is $s, '321@', 'disabled';

done_testing;
