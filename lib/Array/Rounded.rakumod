my class Array::Rounded is Array {
    method AT-POS(    $index        ) { nextwith $index.round        }
    method ASSIGN-POS($index, \value) { nextwith $index.round, value }
    method BIND-POS(  $index, \value) { nextwith $index.round, value }
    method DELETE-POS($index        ) { nextwith $index.round        }

    # For some reason we need to copy/paste this from Array to allow
    # for typed rounded arrays.
    method ^parameterize(Mu:U \arr, Mu \of) {
        use nqp;
        if nqp::isconcrete(of) {
            die "Can not parameterize {arr.^name} with {of.raku}"
        }
        else {
            my $what := arr.^mixin(Array::Typed[of]);
            # needs to be done in COMPOSE phaser when that works
            $what.^set_name("{arr.^name}[{of.^name}]");
            $what
        }
    }
}

my constant Rounded is export = Array::Rounded;

my constant &old-same = &postcircumfix:<[ ]>;
proto sub postcircumfix:<[ ]>($, |) is export {*}

multi sub postcircumfix:<[ ]>(Array::Rounded:D \SELF, Int:D $index) {
    old-same SELF, $index
}
multi sub postcircumfix:<[ ]>(Array::Rounded:D \SELF, Int:D $index, |c) {
    old-same SELF, $index, |c
}

multi sub postcircumfix:<[ ]>(Array::Rounded:D \SELF, Iterable:D \index) {
    index.iterator.push-all(my $buffer := IterationBuffer.CREATE);
    old-same SELF, $buffer.List.map(*.round)
}
multi sub postcircumfix:<[ ]>(Array::Rounded:D \SELF, Iterable:D \index, |c) {
    index.iterator.push-all(my $buffer := IterationBuffer.CREATE);
    old-same SELF, $buffer.List.map(*.round), |c
}

multi sub postcircumfix:<[ ]>(Array::Rounded:D \SELF, Callable:D $index) {
    old-same SELF, $index(SELF.elems)
}
multi sub postcircumfix:<[ ]>(Array::Rounded:D \SELF, Callable:D $index, |c) {
    old-same SELF, $index(SELF.elems), |c
}

multi sub postcircumfix:<[ ]>(Array::Rounded:D \SELF, Whatever:D $index) {
    old-same SELF, $index
}
multi sub postcircumfix:<[ ]>(Array::Rounded:D \SELF, Whatever:D $index, |c) {
    old-same SELF, $index, |c
}

multi sub postcircumfix:<[ ]>(Array::Rounded:D \SELF, List:D \index) {
    old-same SELF, index.map(*.round)
}
multi sub postcircumfix:<[ ]>(Array::Rounded:D \SELF, List:D \index, |c) {
    old-same SELF, index.map(*.round), |c
}

multi sub postcircumfix:<[ ]>(Array::Rounded:D \SELF, Any:D \index) {
    old-same SELF, index.round
}
multi sub postcircumfix:<[ ]>(Array::Rounded:D \SELF, Any:D \index, |c) {
    old-same SELF, index.round, |c
}

=begin pod

=head1 NAME

Array::Rounded - arrays that round indices while accessing elements

=head1 SYNOPSIS

=begin code :lang<raku>

use Array::Rounded;

my @a is Rounded = ^10;
say @a[1.5];  # 2

=end code

=head1 DESCRIPTION

Array::Rounded provides a subclass of C<Array> called C<Rounded> that
will B<round> non-integer indices on the array, rather than truncating
them.  Other than that, any arrays created with the C<Rounded> class
will act as a normal C<Array>.

=head1 IMPLEMENTATION DETAILS

Because C<postcircumfix:<[ ]>> already intifies any non-integer value
in current and possibly future versions of the Raku Programming Language,
this module also exports some C<postcircumfix:<[ ]>> candidates to
circumvent the premature intifications.

Also, due to some issues with native arrays, it has as yet been
impossible to provide similar functionality for native arrays.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Array-Rounded .
Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a
L<small sponsorship|https://github.com/sponsors/lizmat/>  would mean a great
deal to me!

=head1 COPYRIGHT AND LICENSE

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
