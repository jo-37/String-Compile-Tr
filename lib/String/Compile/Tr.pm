package String::Compile::Tr;

use 5.006;
use strict;
use warnings;
use Carp;
use overload;
use PadWalker qw(peek_my peek_our);

=encoding UTF-8

=head1 NAME

String::Compile::Tr - compile tr/// expressions

=head1 VERSION

Version 0.02_01

=cut

our
$VERSION = '0.02_01';


=head1 SYNOPSIS

    use String::Compile::Tr;
    
    my $search = '/+=';
    my $replace = '-_';
    my $s = 'De/0xv5y3w8BpLF8ubOo+w==';
    trgen($search, $replace)->($s);
    # $s = 'De-0xv5y3w8BpLF8ubOo_w'

=head1 DESCRIPTION

The usual approach when operands of a C<tr///> operator shall be
variables is to C<eval> a string with interpolated operands.
The drawback of this approach are possible unwanted side effects induced
by the variables' content, e.g.

    $search = '//;warn-trapped;$@=~tr/';
    eval "tr/$search//d";

C<String::Compile::Tr> offers an alternative where the content of a
variable can be used as operand without C<eval>'ing it. 

The sub named C<trgen> provides the functionally of the C<tr///>
operator on variables without C<eval>'ing them.
This sub is imported by default with C<use String::Compile::Tr>.

C<trgen(*SEARCH*, *REPLACE*, *OPT*)> returns a sub ref that performs
almost the same as C<tr/*SEARCH*/*REPLAC*/*OPT*>, but allows variable
operands.
It the sub is called with an argument C<$str>, it behaves like C<$str =~
tr///> and without it operates on C<$_>.

=head1 FUNCTIONS

=head2 trgen

    trgen(search, [replace], [options])

C<trgen> returns an anonymous subroutine that will perform a similar
operation as C<tr/search/replace/options>.
It can be use multiple times on different targets.

=head1 ERRORS

When the C<tr> operation cannot be compiled, C<trgen> will return
C<undef>.

=head1 EXAMPLES

A proposed usage of this module is:

    use String::Compile::Tr;

    my $search = 'abc';
    my $replace = '123';
    my $tr = trgen($search, $replace);
    my $s = 'fedcab';
    $tr->($s);
    # $s is 'fed321' now

or

    my @list = qw(foo bar);
    my $tr = trgen('abf', 'etg');
    $tr->() for @list;
    # @list is now ('goo', 'ter');

=head1 RESTRICTIONS

Character ranges are not supported in the search and replace lists.
All characters are interpreted literally.

=head1 AUTHOR

Jörg Sommrey, C<< <git at sommrey.de> >>

=head1 LICENSE AND COPYRIGHT

This software is copyright (c) 2025 by Jörg Sommrey.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 SEE ALSO

L<perlop/"tr/*SEARCHLIST*/*REPLACEMENTLIST*/cdsr">,
L<perlfunc/eval EXPR>,
L<overload/Overloading Constants>,
L<PadWalker>

=cut

package String::Compile::Tr::Overload;
use overload;

sub _ovl_tr {
    my (undef, $str, $context) = @_;
    our ($search, $replace);

    return $str unless $context eq 'tr';
    return $search if $str =~ /^:search:$/;
    return $replace if $str =~ /^:replace:$/;
    
    $str;
}

sub import {
    overload::constant q => \&_ovl_tr;
}

package String::Compile::Tr;

use Exporter::Shiny our @EXPORT = qw(trgen);

*search = *String::Compile::Tr::Overload::search;
*replace = *String::Compile::Tr::Overload::replace;

BEGIN {
    String::Compile::Tr::Overload->import;
}

sub trgen {
    local our ($search, $replace);
    my $options;
    ($search, $replace, $options) = @_;
    $replace = '' unless defined $replace;
    $options = '' unless defined $options;
    my ($opt) = $options =~ /^([cdsr]*)$/;
    $opt = '' unless defined $opt;
    my $template = <<'EOS';
    sub {
        if (@_) {
            return $_[0] =~ tr/:search:/:replace:/%1$s;
        }
        tr/:search:/:replace:/%1$s;
    }
EOS
    my $code = sprintf $template, $opt;

    eval $code;
}

1;
