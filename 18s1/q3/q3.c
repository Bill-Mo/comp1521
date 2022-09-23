// COMP1521 18s1 Q2 ... addStudent() function
// - insert a Student record into a file in order

#include "Students.h"
#include <sys/types.h>
#include <unistd.h>

// put any other required #include's here

void addStudent(int fd, Student stu)
{
	// your code goes here
	Student compared;
	read(fd, compared, sizeof(Student));
	while (compared.id < stu.id) {
	    read(fd, compared, sizeof(Student));
    }
	lseek(fd, -sizeof(Student), SEEK_CUR);
    write(fd, stu, sizeof(Student));
}
