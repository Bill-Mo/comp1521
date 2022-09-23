#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include "database.h"

#define DATABASE_FILE "studentdata.db"

int main (int argc, char * argv[]) {

    /*
     * To interact with the database:
     *
     * w id name program 
     *  - w(rites) record to database
     *  - Prints "success\n" on success, "fail\n" on any kind failure
     * f id              
     *  - f(etches) record with id from database
     *  - prints id, name and program followed by newline on success
     *  - prints "fail\n" on any sort of failure
     * d id
     *  - d(eletes) record with id
     *  - prints "success\n" on success, "fail\n" on any kind of failure
     *
     */

    
    FILE * file_ptr;

    if(argc > 1 && strcmp(argv[1],"-new") == 0){
        // Create database if it doesn't exist, emptying it
        file_ptr = fopen(DATABASE_FILE, "w");
        fclose(file_ptr);
    } else {
         // Create database if it doesn't exist, without emptying it
        file_ptr = fopen(DATABASE_FILE, "a");
        fclose(file_ptr);
    }
    // Make sure program doesn't buffer prints
    setbuf(stdout,NULL);
    
    char buf[BUFSIZ];
    while (fgets(buf, BUFSIZ, stdin)) {
        int id;
        int check;
        struct record rec;

        switch(buf[0]) {
            case 'w': // Write
                check = sscanf(buf, "w %d %s %s", &rec.id, rec.name, rec.program);
                if (check != 3) {
                    printf("fail\n");
                    break;
                }

                printf(write_record(rec) ? "success\n" : "fail\n" );
                break;

            case 'f': // Fetch
                check = sscanf(buf, "f %d", &id);
                if (check != 1) {
                    printf("fail\n");
                    break;
                }

                struct record * res = fetch_by_id(id);
                if (res == NULL) {
                    printf("fail\n");
                    break;
                }
                
                // print the result
                printf("%d %s %s\n", res->id, res->name, res->program);               
                break;
                
            case 'd': // Delete
                check = sscanf(buf, "d %d", &id);
                if (check != 1) {
                    printf("fail\n");
                    break;
                }

                printf(delete_by_id(id) ? "success\n" : "fail\n" );
                break;
            default:
                printf("fail\n");
                break;
        }
    } 

    return 0;
}

//Returns 1 on success
int write_record(struct record rec) {
    //TODO
    int fd;
    fd = open(DATABASE_FILE, O_RDWR | O_APPEND);
    struct record toBeRead;
    while (read(fd, &toBeRead, sizeof(struct record)) != 0) {
        if (toBeRead.id == rec.id) {
            if (lseek(fd, -sizeof(struct record), SEEK_CUR) == -1) {
                perror("lseek");
                return -1;
            }
            if (write(fd, &rec, sizeof(rec)) == -1) {
                perror("write");
                return -1;
            }
            return 1;
        }
    }
    if (write(fd, &rec, sizeof(rec)) == -1) {
        perror("write");
        return -1;
    }
    return 1; //This line is just to make it compile
                //You may need to modify it
}

//Returns NULL on failure
struct record * fetch_by_id(int id) {
    //TODO
    int fd;
    struct record *toBeRead = malloc(sizeof(struct record));
    fd = open(DATABASE_FILE, O_RDONLY);
    toBeRead->id = -1;
    int readReturn = 1;
    while (id != toBeRead->id && readReturn != 0) {
        readReturn = read(fd, toBeRead, sizeof(struct record));
        if (readReturn == -1) {
            perror("read");
            return NULL;
        }
    }
    if (readReturn == 0) {
        return NULL;
    }
    return toBeRead; //This line is just to make it compile
                   //You may need to modify it
}

//returns 1 on success
int delete_by_id(int id) {
    // TODO
    int fd; 
    struct record *toBeDeleted = malloc(sizeof(struct record));
    fd = open(DATABASE_FILE, O_RDWR);
    toBeDeleted->id = 1;
    int readReturn = 1;
    while (id != toBeDeleted->id && readReturn != 0) {
        readReturn = read(fd, toBeDeleted, sizeof(struct record));
        if (readReturn == -1) {
            perror("read");
            return -1;
        }
    }
    if (readReturn == 0) {
        return -1;
    }
    if (lseek(fd, -sizeof(struct record), SEEK_CUR) == -1) {
        perror("lseek");
        return -1;
    }
    toBeDeleted->id = 1;
    if (write(fd, toBeDeleted, sizeof(struct record)) == -1) {
        perror("write");
        return -1;
    }
    return 1;  //This line is just to make it compile
                //You may need to modify it
}
