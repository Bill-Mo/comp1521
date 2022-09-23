# asterisks.s
#
#int main(void){
#    int i, n;
#    printf("Enter the number of asterisks: ");   
#    scanf("%d",&n);
#    i = 0;
#    while(i < n){
#        printf("*\n");
#        i++;
#    }
#    return 0;
#}

### Global data

   .data

input_msg:
   .asciiz "Enter the number of asterisks: "
eol:
   .asciiz "\n"
asterisk:
   .asciiz "*"


### main() function
   .text
   .globl main

main:
   la    $a0, input_msg
   li    $v0, 4
   syscall                  # printf("Enter the number of asterisks: ");

   li    $v0, 5
   syscall                  # scanf("%d", into $v0)
   move $s0, $v0            # store n in $s0

# ... TODO: your code for the body of main() goes here ..
   li    $t0, 1
TopOfLoop: 
   beqz  $s0,  BottomOfLoop # while(n != 0)
   li    $a0, '*'
   li    $v0, 11
   syscall                  # printf("*");
   
   li    $a0, '\n'
   li    $v0, 11
   syscall                  # printf("\n");
   
   sub   $s0, $s0, $t0      #n = n - 1;
   beq   $s0, $s0, TopOfLoop
BottomOfLoop:

   li    $v0, 0
   jr    $ra                # return 0

