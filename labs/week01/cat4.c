// Copy input to output
// CP1521

#include <stdlib.h>
#include <stdio.h>

void copy(FILE *, FILE *);

int main(int argc, char *argv[])
{
	int i = 1;
	if (argc == 1) {
	    copy(stdin,stdout);
	} else {
	    while (argc != i) {
	        FILE *file = fopen(argv[i], "r");
	        if (file == NULL) {
	            printf("Can't read %s", argv[i]);
	        } else {
	            copy(file, stdout);
	            fclose(file);
	        }
	        i++;
	    }
	}
	return EXIT_SUCCESS;
}

// Copy contents of input to output
// Assumes both files open in appropriate mode

void copy(FILE *input, FILE *output)
{
    char i[BUFSIZ];
    while (fgets(i, BUFSIZ, input) != NULL) {
        fputs(i, output);
    }
}
