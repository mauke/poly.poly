int(//+$@ -- ); q~ \
 ) = 0 {-
x);
#include <stdio.h>
int main(void) { for (;;) puts("y"); } /*
~;

sub putStr {
    my ($xs) = @_;
    for (; $xs; $xs = $xs->[1]) {
        print $xs->[0];
    }
}

sub cycle {
    my ($str) = @_;
    my $p = \my $xs;
    for my $c (split //, $str) {
        $$p = [$c];
        $p = \$$p->[1];
    }
    $$p = $xs;
    $xs
}

{$main--} -- $main; $

main = putStr (cycle "y\n"); -- $main; # */
