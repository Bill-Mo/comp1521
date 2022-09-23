// BigNum.h ... LARGE positive integer values

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <ctype.h>
#include "BigNum.h"

// Initialise a BigNum to N bytes, all zero
void initBigNum(BigNum *n, int Nbytes)
{
   // TODO
    int i = 0;
    n->nbytes = Nbytes;
    n->bytes = malloc(Nbytes * sizeof (char));
    assert(n->bytes != NULL);
    while (i < Nbytes) {
        n->bytes[i] = '0';
        i++;
    }
}

// Add two BigNums and store result in a third BigNum
void addBigNums(BigNum n, BigNum m, BigNum *res)
{
   // TODO
    int i = 0, carry = 0, biggestSize, num;
    if (n.nbytes > m.nbytes) {
        biggestSize = n.nbytes;
    } else {
        biggestSize = m.nbytes;
    }
    while (n.bytes[i] != '\0' && m.bytes[i] != '\0') {
        num = 0;
        if (carry == 1) {
            num++;
            carry--;
        }
        num = num + n.bytes[i] - '0' + m.bytes[i] - '0';
        if (num >= 10) {
            num = num - 10;
            carry++;
        }
        res->bytes[i] = num + '0';
        i++;
    }
    if (carry == 1) {
        res->bytes = realloc(res->bytes, (biggestSize + 1) * sizeof(char));
        assert(res->bytes != NULL);
        res->bytes[i + 1] = '1';
    }
}

// Set the value of a BigNum from a string of digits
// Returns 1 if it *was* a string of digits, 0 otherwise
int scanBigNum(char *s, BigNum *n)
{
   // TODO
    int i = 0;
    while (s[i] != '\0') {
        if ((s[i] < '0' || s[i] > '9') && s[i] != ' ') {
            return 0;
        }
        i++;
    }
    i = 0;
    while (s[i] != '\0') {
        i++;
    }
    int size = i - 1;
    i = 0;
    while (size >= 0) {
        if (s[size] != ' ') {
            n->bytes[i] = s[size];
            i++;
        }
        size--;
    }
    return 1;
}

// Display a BigNum in decimal format
void showBigNum(BigNum n)
{
   // TODO
    while (n.bytes[n.nbytes - 1] == '0') {
        n.nbytes--;
    }
    if (n.nbytes == 0) {
        putchar('0');
    }
    while (n.nbytes > 0) {
        n.nbytes--;
        putchar(n.bytes[n.nbytes]);
    }
}

void freeBigNum(BigNum n){
   // TODO
    free(n.bytes);
}

