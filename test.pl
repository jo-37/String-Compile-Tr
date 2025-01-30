#!/usr/bin/perl

use 5.006;
use Test2::V0;
#use warnings FATAL => 'all';
use Carp::Always;


use Syntax::Feature::TrVars;
use feature 'say';
    
{
    my $bad = '//;warn-trapped;$@=~tr/';
    my $s = 'abcdefghijklmnopqrstuvwxyz/;-$=~';
    eval "\$s =~ tr/$bad//d; 1" or warn $@;
    say "double quotes: $s";
    eval '$s =~ tr/$bad//d; 1' or warn $@;
    say "single quotes: $s";
    $s = 'abcdefghijklmnopqrstuvwxyz/;-$=~';
    $s =~ tr{-adenprtw/;$=~}{}d;
    say "no eval:       $s";
}

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

{
    our $glob = 'a';
    {
        local $glob = 'b';
        my $s = 'ab';
        ok lives {eval '$s =~ tr/$glob/X/; 1' or die $@},
            'run local', $@;
        is $s, 'aX', 'use local';
    }
}

use feature 'state';
sub test1 {
    my $arg = shift;
    state $state;
    if ($arg) {
        $state = 'b';
        pass 'init';
        return;
    }
    my $s = 'ab';
    ok lives {eval '$s =~ tr/$state/X/; 1' or die $@},
        'run state', $@;
    is $s, 'aX', 'use state';
}

test1(-dummy);
test1();

no Syntax::Feature::TrVars;

$s = 'cba$';
$s =~ tr/$abc/@123/;
is $s, '321@', 'disabled';

done_testing;
