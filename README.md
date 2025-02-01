# NAME

String::Compile::Tr - compile tr/// expressions

# VERSION

Version 0.02\_01

# SYNOPSIS

```perl
use String::Compile::Tr;

my $search = '/+=';
my $replace = '-_';
my $s = 'De/0xv5y3w8BpLF8ubOo+w==';
trgen($search, $replace)->($s);
# $s = 'De-0xv5y3w8BpLF8ubOo_w'
```

# DESCRIPTION

The usual approach when operands of a `tr///` operator shall be
variables is to `eval` a string with interpolated operands.
The drawback of this approach are possible unwanted side effects induced
by the variables' content, e.g.

```
$search = '//;warn-trapped;$@=~tr/';
eval "tr/$search//d";
```

`String::Compile::Tr` offers an alternative where the content of a
variable can be used as operand without `eval`'ing it. 

The sub named `trgen` provides the functionally of the `tr///`
operator on variables without `eval`'ing them.
This sub is imported by default with `use String::Compile::Tr`.

`trgen(*SEARCH*, *REPLACE*, *OPT*)` returns a sub ref that performs
almost the same as `tr/*SEARCH*/*REPLAC*/*OPT*`, but allows variable
operands.
It the sub is called with an argument `$str`, it behaves like `$str =~
tr///` and without it operates on `$_`.

# FUNCTIONS

## trgen

```
trgen(search, [replace], [options])
```

`trgen` returns an anonymous subroutine that will perform a similar
operation as `tr/search/replace/options`.
It can be use multiple times on different targets.

# ERRORS

When the `tr` operation cannot be compiled, `trgen` will return
`undef`.

# EXAMPLES

A proposed usage of this module is:

```perl
use String::Compile::Tr;

my $search = 'abc';
my $replace = '123';
my $tr = trgen($search, $replace);
my $s = 'fedcab';
$tr->($s);
# $s is 'fed321' now
```

or

```perl
my @list = qw(foo bar);
my $tr = trgen('abf', 'etg');
$tr->() for @list;
# @list is now ('goo', 'ter');
```

# RESTRICTIONS

Character ranges are not supported in the search and replace lists.
All characters are interpreted literally.

# AUTHOR

Jörg Sommrey, `<git at sommrey.de>`

# LICENSE AND COPYRIGHT

This software is copyright (c) 2025 by Jörg Sommrey.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

# SEE ALSO

["tr/\*SEARCHLIST\*/\*REPLACEMENTLIST\*/cdsr" in perlop](https://metacpan.org/pod/perlop#tr-SEARCHLIST-REPLACEMENTLIST-cdsr),
["eval EXPR" in perlfunc](https://metacpan.org/pod/perlfunc#eval-EXPR),
["Overloading Constants" in overload](https://metacpan.org/pod/overload#Overloading-Constants),
[PadWalker](https://metacpan.org/pod/PadWalker)
