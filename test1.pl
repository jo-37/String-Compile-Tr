#!/usr/bin/perl

#use v5.16;
#use warnings FATAL => 'all';
#use autodie;
#use utf8;
#use charnames qw(:full :short);
#use experimental qw(signatures postderef);

use feature 'say';
use Syntax::Feature::TrVars;

our $in = 'abc';
$s = 'fedcab';
eval '$s =~ tr/$in/123/; 1' or warn $@;
say $s;
