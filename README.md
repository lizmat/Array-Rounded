[![Actions Status](https://github.com/lizmat/Array-Rounded/actions/workflows/linux.yml/badge.svg)](https://github.com/lizmat/Array-Rounded/actions) [![Actions Status](https://github.com/lizmat/Array-Rounded/actions/workflows/macos.yml/badge.svg)](https://github.com/lizmat/Array-Rounded/actions) [![Actions Status](https://github.com/lizmat/Array-Rounded/actions/workflows/windows.yml/badge.svg)](https://github.com/lizmat/Array-Rounded/actions)

NAME
====

Array::Rounded - arrays that round indices while accessing elements

SYNOPSIS
========

```raku
use Array::Rounded;

my @a is Rounded = ^10;
say @a[1.5];  # 2
```

DESCRIPTION
===========

Array::Rounded provides a subclass of `Array` called `Rounded` that will **round** non-integer indices on the array, rather than truncating them. Other than that, any arrays created with the `Rounded` class will act as a normal `Array`.

IMPLEMENTATION DETAILS
======================

Because `postcircumfix:<[ ]>` already intifies any non-integer value in current and possibly future versions of the Raku Programming Language, this module also exports some `postcircumfix:<[ ]>` candidates to circumvent the premature intifications.

Also, due to some issues with native arrays, it has as yet been impossible to provide similar functionality for native arrays.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Array-Rounded . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2022, 2025 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

