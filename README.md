# NAME

Syntax::Feature::TrVars - process variables in tr/// operands

# VERSION

Version 0.01

# SYNOPSIS

```perl
use Syntax::Feature::TrVars;

my $search = '/+=';
my $replace = '-_';
my $s = 'De/0xv5y3w8BpLF8ubOo+w==';
eval '$s =~ tr/$search/$replace/d';
# $s = 'De-0xv5y3w8BpLF8ubOo_w'

no Syntax::Feature::TrVars;

$s = 'cba$';
$s =~ tr/$abc/@123/;
# $s = '321@';
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

`Syntax::Feature::TrVars` offers an alternative where the content of a
variable can be used as operand without `eval`'ing it. 

When `Syntax::Feature::TrVars` is imported, it overloads the arguments
of the `tr/*SEARCH*/*REPLACE*/` operator.
When any of `*SEARCH*` or `*REPLACE*` has the form "`$name`",
then `$name` is taken as the name of a lexically scoped, simple,
scalar variable, whose content is used as the actual operand.

`$name` must be declared as `my $name`, `state $name` or `our $name`
(possibly `local`'ized) - anything else will fail.

As the operands of the `tr///` operator are processed at compile time,
this feature should be used within a singly quoted string `eval`.
The content of `$name` will not be `eval`'ed, may contain the `tr`
separator and no special measures are required in _taint mode_.
The usage outside of an `eval` is possible but of low value.

By specifying `no Syntax::Feature::TrVars`, this feature can be
disabled.

# ERRORS

When a referenced variable is not defined in the lexical scope of the
`tr///` execution, an exception `"$name" not defined` is thrown.

# EXAMPLES

A proposed usage of this module is:

```perl
use Syntax::Feature::TrVars;

my $search = 'abc';
my $replace = '123';
my $s = 'fedcab';
eval '$s =~ tr/$search/$replace/; 1' or warn $@;
# $s is 'fed321' now
```

Note that result of `tr` in scalar context is the number of characters
replaced or the result of the transliteration under the `/r` option,
both of which may legitimately evaluate to `false`.
Ending the `eval`'ed string with `; 1` makes sure `eval` returns
`true` if there is no error.

The example mentioned in ["DESCRIPTION"](#description) does no harm:

```perl
use Syntax::Feature::TrVars;

my $search = '//;warn-trapped;$@=~tr/';
my $s = 'abcdefghijklmnopqrstuvwxyz/;-$=~';
eval '$s =~ tr/$search//d; 1' or warn $@;
# $s is 'bcfghijklmoqsuvxyz'
```

It is roughly equivalent to:

```
$s =~ tr{-adenprtw/;$=~}{}d;
```

# CAVEATS

An exception thrown by `Syntax::Feature::TrVals` within an `eval` will
be trapped.
Make sure to capture such exceptions lest they get ignored.
See ["EXAMPLES"](#examples).

# BUGS

There are some rare cases where [PadWalker](https://metacpan.org/pod/PadWalker) returns `undef` when
it should not.
Try to avoid equally named lexical variables at the same stack level.

# RESTRICTIONS

Character ranges are not supported in the content of a referenced variable.
A hyphen will always be interpreted literally.

# AUTHOR

Jörg Sommrey, `<git at sommrey.de>`

# LICENSE AND COPYRIGHT

This software is copyright (c) 2025 by Jörg Sommrey.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

# SEE ALSO

["tr/\*SEARCHLIST\*/\*REPLACEMENTLIST\*/cdsr" in perlop](https://metacpan.org/pod/perlop#tr-SEARCHLIST-REPLACEMENTLIST-cdsr),
["Overloading Constants" in overload](https://metacpan.org/pod/overload#Overloading-Constants),
[PadWalker](https://metacpan.org/pod/PadWalker)
