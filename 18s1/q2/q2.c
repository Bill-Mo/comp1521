// COMP1521 18s1 Q2 ... shred() function
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
// put any needed #include's here

void shred(int infd, int outfd)
{
	// put your code here
	char buffer[64];
    int random;
	while (read(infd, buffer, 64) != 0) {
	    for (int i = 0; i < 64; i++) {
	        random = rand() % 26;
	        buffer[i] = 'A' + random;
	    }
	    write(outfd, buffer, 64);
	    write(outfd, "\n", 1);
	}
}
