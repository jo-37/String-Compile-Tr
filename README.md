# NAME

String::Compile::Tr - compile tr/// expressions

# VERSION

Version 0.04\_01

# SYNOPSIS

```perl
use String::Compile::Tr;

my $search = '/+=';
my $replace = '-_';
my $s = 'De/0xv5y3w8BpLF8ubOo+w==';
trgen($search, $replace, 'd')->($s);
# $s = 'De-0xv5y3w8BpLF8ubOo_w'
```

# DESCRIPTION

The usual approach when operands of a `tr///` operator shall be
variables is to apply `eval` on a string to interpolate the operands.
The drawback of this approach are possible unwanted side effects induced
by the variables' content, e.g.

```
$search = '//,warn-trapped,$@=~tr/';
eval "tr/$search//d";
```

`String::Compile::Tr` offers an alternative where the content of a
variable can be used as operand without `eval`'ing it. 

`trgen(*SEARCH*, *REPLACE*, *OPT*)` compiles an anonymous sub that
performs almost the same operation as `tr/*SEARCH*/*REPLACE*/*OPT*`,
but allows variable operands.

`trgen` is imported by default by `use String::Compile::Tr`.

# FUNCTIONS

## trgen

```
trgen(search, replace, [options])
```

`trgen` returns an anonymous subroutine that performs an almost identical 
operation as `tr/search/replace/options`.
The `tr` target may be given as an argument to the generated sub
or is the default input `$_` otherwise.

# ERRORS

`trgen` will throw an exception if an invalid option is specified.

When the `tr` operation cannot be compiled, `trgen` will return
`undef`.

# EXAMPLES

Proposed usages of this module are:

```perl
use String::Compile::Tr;

my $search = 'abc';
my $replace = '123';
my $tr = trgen($search, $replace);
my $s = 'fedcba';
$tr->($s);
# $s is 'fed321' now

my @list = qw(axy bxy cxy);
$tr->() for @list;
# @list is now ('1xy', '2xy', '3xy');

print trgen($search, $replace, 'r')->('fedcba'); # 'fed321'
```

# RESTRICTIONS

Character ranges are not supported in the search and replace lists.
All characters are interpreted literally.
This is caused by the fact that `tr` does not support these neither.
It's the compiler that expands character ranges in `tr`'s operands
before handing them over.

# AUTHOR

Jörg Sommrey, `<git at sommrey.de>`

# LICENSE AND COPYRIGHT

This software is copyright (c) 2025 by Jörg Sommrey.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

# SEE ALSO

["tr/\*SEARCHLIST\*/\*REPLACEMENTLIST\*/cdsr" in perlop](https://metacpan.org/pod/perlop#tr-SEARCHLIST-REPLACEMENTLIST-cdsr)

["eval" in perlfunc](https://metacpan.org/pod/perlfunc#eval)

[Exporter::Tiny::Manual::Importing](https://metacpan.org/pod/Exporter%3A%3ATiny%3A%3AManual%3A%3AImporting)

[Regexp::Tr](https://metacpan.org/pod/Regexp%3A%3ATr) provides a similar functionality, though this `eval`'s
its oprands.
