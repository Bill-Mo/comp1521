#include <stdio.h>
#define BITS_IN_BYTE 8
 
int main(void){
    int j;
    j = BITS_IN_BYTE;
    while (j > 0) {
        j = j - 1;
        printf("%d", (c >> j) & 1);
    }
    printf("\n");
    return 0;
}
