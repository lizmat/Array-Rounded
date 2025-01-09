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

# Keep any normal array working
multi sub postcircumfix:<[ ]>(Array:D \SELF,  Any:D  \index) {
    old-same SELF, index
}
multi sub postcircumfix:<[ ]>(Array:D \SELF,  Any:D  \index, |c) {
    old-same SELF, index, |c
}

# vim: expandtab shiftwidth=4
