// CP1521 lab exercises
//
// generate the opcode for an addi instruction

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "addi.h"

// return the MIPS opcode for addi $t,$s, i
uint32_t addi(int t, int s, int i) {
    unsigned int value = 0b00100000000000000000000000000000;
    uint32_t newS = s << 21;
    uint32_t newT = t << 16;
    uint32_t newI = i;
    //s = s << 21;
    //t = t << 16;
    value = value | newS;
    value = value | newT;
    newI = 0xffff & newI;
    value = value | newI;
    return value; // REPLACE WITH YOUR CODE

}
