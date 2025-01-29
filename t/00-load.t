#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Syntax::Feature::TrVars' ) || print "Bail out!\n";
}

diag( "Testing Syntax::Feature::TrVars $Syntax::Feature::TrVars::VERSION, Perl $], $^X" );
