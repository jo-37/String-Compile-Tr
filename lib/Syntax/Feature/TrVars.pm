package Syntax::Feature::TrVars;

use 5.006;
use strict;
use warnings;
use Carp;
use overload;
use PadWalker qw(peek_my peek_our);

=encoding UTF-8

=head1 NAME

Syntax::Feature::TrVars - process variables in tr/// operands

=head1 VERSION

Version 0.01

=cut

our
$VERSION = '0.01';


=head1 SYNOPSIS

    use Syntax::Feature::TrVars;
    
    my $search = '/+=';
    my $replace = '-_';
    my $s = 'De/0xv5y3w8BpLF8ubOo+w==';
    eval '$s =~ tr/$search/$replace/d; 1' or warn $@;
    # $s = 'De-0xv5y3w8BpLF8ubOo_w'

    no Syntax::Feature::TrVars;

    $s = 'cba$';
    $s =~ tr/$abc/@123/;
    # $s = '321@';

=head1 DESCRIPTION

The usual approach when operands of a C<tr///> operator shall be
variables is to C<eval> a string with interpolated operands.
The drawback of this approach are possible unwanted side effects induced
by the variables' content, e.g.

    $search = '//;warn -gotcha;tr/';
    eval "tr/$search//d";

C<Syntax::Feature::TrVars> offers an alternative where the content of a
variable can be used as operand without C<eval>'ing it. 

When C<Syntax::Feature::TrVars> is imported, it overloads the arguments
of the C<tr/*SEARCH*/*REPLACE*/> operator.
When any of C<*SEARCH*> or C<*REPLACE*> has the form "C<$name>",
then C<$name> is taken as the name of a lexically scoped, simple,
scalar variable, whose content is used as the actual operand.

C<$name> must be declared as C<my $name> or C<our $name> - 
anything else will fail.

As the operands of the C<tr///> operator are processed at compile time,
this feature should be used within a singly quoted string C<eval>.
The content of C<$name> will not be C<eval>'ed, may contain the C<tr>
separator and no special measures are required in I<taint mode>.
The usage outside of an C<eval> is possible but of low value.

By specifying C<no Syntax::Feature::TrVars>, this feature can be
disabled.

=head1 AUTHOR

Jörg Sommrey, C<< <git at sommrey.de> >>

=head1 LICENSE AND COPYRIGHT

This software is copyright (c) 2025 by Jörg Sommrey.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

sub _ovl_tr {
    my (undef, $str, $context) = @_;
    # pass everything unmodified that is not an operand of tr///
    return $str unless $context eq 'tr';

    # pass regular operands
    return $str unless $str =~ /^\$/;

    # search for variable
    for my $peek (\&peek_my, \&peek_our) {
        my $vars = $peek->(1);
        next unless exists $vars->{$str};
        my $ret = ${$vars->{$str}};
        return $ret if defined $ret;
        croak qq("$str" not defined);
    }

    # illegal argument
    croak qq("$str" not defined);
}

sub import {
    overload::constant q => \&_ovl_tr;
}

sub unimport {
    overload::remove_constant q => \&_ovl_tr;
}

1;
