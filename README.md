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
eval '$s =~ tr/$search/$replace/d; 1' or warn $@;
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
$search = '//;warn -gotcha;tr/';
eval "tr/$search//d";
```

`Syntax::Feature::TrVars` offers an alternative where the content of a
variable can be used as operand without `eval`'ing it. 

When `Syntax::Feature::TrVars` is imported, it overloads the arguments
of the `tr/*SEARCH*/*REPLACE*/` operator.
When any of `*SEARCH*` or `*REPLACE*` has the form "`$name`",
then `$name` is taken as the name of a lexically scoped, simple,
scalar variable, whose content is used as the actual operand.

`$name` must be declared as `my $name` or `our $name` - 
anything else will fail.

As the operands of the `tr///` operator are processed at compile time,
this feature should be used within a singly quoted string `eval`.
The content of `$name` will not be `eval`'ed, may contain the `tr`
separator and no special measures are required in _taint mode_.
The usage outside of an `eval` is possible but of low value.

By specifying `no Syntax::Feature::TrVars`, this feature can be
disabled.

# AUTHOR

Jörg Sommrey, `<git at sommrey.de>`

# LICENSE AND COPYRIGHT

This software is copyright (c) 2025 by Jörg Sommrey.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
