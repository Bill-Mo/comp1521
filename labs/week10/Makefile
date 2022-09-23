# CP1521 Makefile

CC=gcc
#CFLAGS=-std=gnu99 -Wall -Werror
CFLAGS=-std=gnu99 -Wall -Werror -DDBUG

all: addi mysh

addi: addi.h addi.c test_addi.c
	$(CC) $(CFLAGS) -o addi addi.c test_addi.c		

mysh : mysh.c

clean :
	rm -f mysh *.o core
