#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define MAX_CODE 1000
#define MAX_REGISTERS 32
#define MAX_CHAR 100
#define v0 2
#define a0 4

int numbers_of_bit(int code);
void bit_pattern_translation (int code, char assembler[6], int zeros);
int s_register(int code, int zeros);
int t_register(int code, int zeros, int s);
int d_register(int code, int zeros, int s, int t);
int immediate(int code, int zeros, int s);
void print_assembler(char *assembler, int s, int t, int d, int I);
void execute_assembler(char *assembler, int registers[32], int s, int t, int d, int I, int *PC, int i);
void changed_registers(int registers[MAX_REGISTERS]);
int main (int argc, char * argv[]) {
    FILE * hex = fopen(argv[1], "r");
    int i = 0;
    int registers[MAX_REGISTERS];
    while (i < MAX_REGISTERS) {
        registers[i] = 0;
        i++;
    }
    int code[MAX_CODE];
    i = 0;
    while (i < MAX_CODE && fscanf(hex, "%x", &code[i]) == 1) {
        i++;
    }
    
    int j = 0;
    int PC = 0;
    int number, zeros, s, t, d, I;
    char assembler[6];
    char *mipsLine = assembler;
    
    printf("Program\n");
    while (j < i) {
        number = numbers_of_bit(code[j]);
        zeros = 32 - number;
        bit_pattern_translation(code[j], assembler, zeros);
        s = s_register(code[j], zeros);
        t = t_register(code[j], zeros, s);
        d = d_register(code[j], zeros, s, t);
        I = immediate(code[j], zeros, s);
        printf("%3d: ", j);
        print_assembler(mipsLine, s, t, d, I);
        printf("\n");
        j++;
    }
        
    printf("Output\n");
    while (PC < i) {
        number = numbers_of_bit(code[PC]);
        zeros = 32 - number;
        bit_pattern_translation(code[PC], assembler, zeros);
        s = s_register(code[PC], zeros);
        t = t_register(code[PC], zeros, s);
        d = d_register(code[PC], zeros, s, t);
        I = immediate(code[PC], zeros, s);
        execute_assembler(mipsLine, registers, s, t, d, I, &PC, i);
        registers[0] = 0;
        if (strcmp(assembler, "beq") != 0 && strcmp(assembler, "bne") != 0 ){
            PC++;
        }
    }
    
    printf("Registers After Execution\n");
    changed_registers(registers);
    /*int test = 0x149582a;
    int number = numbers_of_bit(test);
    int zeros = 32 - number;
    printf("\n%d non zero bits\n%d zeros in front of code\n", number, zeros);
    
    char assembler[6] = "bne";
    bit_pattern_translation(test, assembler, zeros);
    printf("The assembler command is %s\n", assembler);
    
    int s = s_register(test, zeros);
    printf("s = %d\n", s);
    
    int t = t_register(test, zeros, s);
    printf("t = %d\n", t);
    
    int d = d_register(test, zeros, s, t);
    printf("d = %d\n", d);
    
    int I = immediate(test, zeros, s);
    printf("I = %d\n", I);
    
    char *mipsLine = assembler;
    print_assembler(mipsLine, s, t, d, I);
    
    int PC = 0;
    execute_assembler(mipsLine, registers, s, t, d, I, &PC);
    
    // For this test, registers are initialized from line 20 to line 23
    changed_registers(registers);
    
    printf("\n");*/
    return 0;
}
int numbers_of_bit(int code) {
    int number = 0;
    while (code != 0) {
        number++;
        code = code >> 1;
    }
    return number;
}

void bit_pattern_translation (int code, char assembler[6], int zeros) {
    
    int frontSix = code >> 26;
    unsigned int i = code << 26;
    unsigned int lastSix = i >> 26;
    //printf("lastSix in decimal: %d\nlastSix in hex: %x\n", lastSix, lastSix);
    if (frontSix != 0b0) {
        if (frontSix == 0b011100) {
            strcpy(assembler, "mul");
        } else if (frontSix == 0b000100) {
            strcpy(assembler, "beq");
        } else if (frontSix == 0b000101) {
            strcpy(assembler, "bne");
        } else if (frontSix == 0b001000) {
            strcpy(assembler, "addi");
        } else if (frontSix == 0b001010) {
            strcpy(assembler, "slti");
        } else if (frontSix == 0b001100) {
            strcpy(assembler, "andi");
        } else if (frontSix == 0b001101) {
            strcpy(assembler, "ori");
        } else if (frontSix == 0b001111) {
            strcpy(assembler, "lui");
        } else {
            strcpy(assembler, "error: bit_pattern_translation\n");
        }
    } else {
        if (lastSix == 0b100000) {
            strcpy(assembler, "add");
        } else if (lastSix == 0b100010) {
            strcpy(assembler, "sub");
        } else if (lastSix == 0b100100) {
            strcpy(assembler, "and");
        } else if (lastSix == 0b100101) {
            strcpy(assembler, "or");
        } else if (lastSix == 0b101010) {
            strcpy(assembler, "slt");
        } else if (lastSix == 0b001100) {
            strcpy(assembler, "sys");
        } else {
            strcpy(assembler, "error: bit_pattern_translation\n");
        }
    }
}

int s_register(int code, int zeros) {
    unsigned int s = code;
    if (zeros <= 6) {
        s = (s << 6) >> 27;
    } else {
        s = s >> 21;
    }
    return s;
}

int t_register(int code, int zeros, int s) {
    unsigned int t = code;
    int zerosForS;
    //printf("zeros is %d\n", zeros);
    if (zeros <= 6) {
        t = (t << 11) >> 27;
    } else {
        if (s >= 16 && s <= 31) {
            zerosForS = 0;
        } else if (s >= 8 && s <= 15) {
            zerosForS = 1;
        } else if (s >= 4 && s <= 7) {
            zerosForS = 2;
        } else if (s >= 2 && s <= 3) {
            zerosForS = 3;
        } else if (s == 1){
            zerosForS = 4;
        } else {
            if (zeros >= 16) {
                return 0;
            } else {
                t = t >> 16;
                return t;
            }
            
        }
        t = t << (zeros + 5 - zerosForS);
        t = t >> 27;
    }
    return t;
}

int d_register(int code, int zeros, int s, int t) {
    unsigned int d = code;
    int zerosForS = 0;
    int zerosForT = 0;
    if (zeros <= 6) {
        d = (d << 16) >> 27;
    } else {
        if (s >= 16 && s <= 31) {
            zerosForS = 0;
        } else if (s >= 8 && s <= 15) {
            zerosForS = 1;
        } else if (s >= 4 && s <= 7) {
            zerosForS = 2;
        } else if (s >= 2 && s <= 3) {
            zerosForS = 3;
        } else if (s == 1){
            zerosForS = 4;
        } else {
            zerosForS = 5;
            if (t >= 16 && t <= 31) {
               zerosForT = 0;
            } else if (t >= 8 && t <= 15) {
                zerosForT = 1;
            } else if (t >= 4 && t <= 7) {
                zerosForT = 2;
            } else if (t >= 2 && t <= 3) {
                zerosForT = 3;
            } else if (t == 1){
                zerosForT = 4;
            } else {
                zerosForT = 5;
            }
        }
        if (zerosForS == 5) {
            if (zerosForT == 5) {
                d = d >> 11;
            } else {
                d = d << (zeros + 5 - zerosForT);
                d = d >> 27;
            }
        } else {
            d = d << (zeros + 10 - zerosForS);
            d = d >> 27;
        }
    }
    return d;
}

int immediate(int code, int zeros, int s) {
    int I = code;
    int zerosForS;
    if (zeros <= 6) {
        I = (I << 16) >> 16;
    } else {
        if (s >= 16 && s <= 31) {
            zerosForS = 0;
        } else if (s >= 8 && s <= 15) {
            zerosForS = 1;
        } else if (s >= 4 && s <= 7) {
            zerosForS = 2;
        } else if (s >= 2 && s <= 3) {
            zerosForS = 3;
        } else if (s == 1){
            zerosForS = 4;
        } else {
            zerosForS = 5;
        }
        I = (I << (zeros + 10 - zerosForS)) >> 16;
    }
    return I;
}

void print_assembler(char *assembler, int s, int t, int d, int I) {
    if (strcmp(assembler, "add") == 0) {
        printf("add  $%d, $%d, $%d", d, s, t);
    } else if (strcmp(assembler, "sub") == 0) {
        printf("sub  $%d, $%d, $%d", d, s, t);
    } else if (strcmp(assembler, "and") == 0) {
        printf("and  $%d, $%d, $%d", d, s, t);
    } else if (strcmp(assembler, "or") == 0) {
        printf("or   $%d, $%d, $%d", d, s, t);
    } else if (strcmp(assembler, "slt") == 0) {
        printf("slt  $%d, $%d, $%d", d, s, t);
    } else if (strcmp(assembler, "mul") == 0) {
        printf("mul  $%d, $%d, $%d", d, s, t);
    } else if (strcmp(assembler, "beq") == 0) {
        printf("beq  $%d, $%d, %d", s, t, I);
    } else if (strcmp(assembler, "bne") == 0) {
        printf("bne  $%d, $%d, %d", s, t, I);
    } else if (strcmp(assembler, "addi") == 0) {
        printf("addi $%d, $%d, %d", t, s, I);
    } else if (strcmp(assembler, "slti") == 0) {
        printf("slti $%d, $%d, %d", t, s, I);
    } else if (strcmp(assembler, "andi") == 0) {
        printf("andi $%d, $%d, %d", t, s, I);
    } else if (strcmp(assembler, "ori") == 0) {
        printf("ori  $%d, $%d, %d", t, s, I);
    } else if (strcmp(assembler, "lui") == 0) {
        printf("lui  $%d, %d", t, I);
    } else if (strcmp(assembler, "sys") == 0) {
        printf("syscall");
    } else {
        printf("error: print_assembler\n");
    }
}

void execute_assembler(char *assembler, int registers[MAX_REGISTERS], int s, int t, int d, int I, int *PC, int i) {
    if (strcmp(assembler, "add") == 0) {
        registers[d] = registers[s] + registers[t];
    } else if (strcmp(assembler, "sub") == 0) {
        registers[d] = registers[s] - registers[t];
    } else if (strcmp(assembler, "and") == 0) {
        registers[d] = registers[s] & registers[t];
    } else if (strcmp(assembler, "or") == 0) {
        registers[d] = registers[s] | registers[t];
    } else if (strcmp(assembler, "slt") == 0) {
        if (registers[s] < registers[t]) {
            registers[d] = 1;
        } else {
            registers[d] = 0;
        }
    } else if (strcmp(assembler, "mul") == 0) {
        registers[d] = registers[s] * registers[t];
    } else if (strcmp(assembler, "beq") == 0) {
        if (registers[s] == registers[t]) {
            *PC += I;
        } else {
            *PC = *PC + 1;
        }
    } else if (strcmp(assembler, "bne") == 0) {
        if (registers[s] != registers[t]) {
            *PC += I;
        } else {
            *PC = *PC + 1;
        }
    } else if (strcmp(assembler, "addi") == 0) {
        registers[t] = registers[s] + I;
    } else if (strcmp(assembler, "slti") == 0) {
         registers[t] = registers[s] < I;
    } else if (strcmp(assembler, "andi") == 0) {
        registers[t] = registers[s] & I;
    } else if (strcmp(assembler, "ori") == 0) {
        registers[t] = registers[s] | I;
    } else if (strcmp(assembler, "lui") == 0) {
        registers[t] = I << 16;
    } else if (strcmp(assembler, "sys") == 0) {
        if (registers[v0] == 1) {
            printf("%d", registers[a0]);
        } else if (registers[v0] == 11) {
            printf("%c", registers[a0]);
        } else if (registers[v0] == 10) {
            *PC = i;
        } else {
            printf("Unknown system call: %d\n", registers[v0]);
            *PC = i;
        }
    } else {
        printf("error : execute_assembler \n");
    }
}

void changed_registers(int registers[MAX_REGISTERS]) {
    for (int i = 0; i < MAX_REGISTERS; i++) {
        if (registers[i] != 0) {
            printf("$%-2d = %d\n", i, registers[i]);
        }
    }
}
