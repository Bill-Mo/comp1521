// where_are_the_bits.c ... determine bit-field order
// CP1521 Lab 03 Exercise
// Written by ...

#include <stdio.h>
#include <stdlib.h>

struct _bit_fields {
   unsigned int a : 4,
                b : 8,
                c : 20;
};

union check {
    struct _bit_fields test;
    char   s[4];
};
int main(void)
{
    union check x;
    x.s[0] = 0b00000000;
    x.s[1] = 0b11111111;
    x.s[2] = 0b10101010;
    x.s[3] = 0b11001100;
    printf("%d\n%d\n%d\n",x.test.a, x.test.b, x.test.c);
    /*
    a = 0 = 0b0000
    b = 240 = 0b11110000
    c = 838319 = 11001100101010101111
    We can see it is stored in small endian way.
    */
    return 0;
}
