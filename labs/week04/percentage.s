#percentage.s 
#Read in two integers: 
#the total number of marks in the exam, 
#and how many marks the student was awarded.
#Print out what percentage of the marks the student was awarded for that exam
#with no decimal places.

#int max;
#int mark;
#int main(void){
#    printf("Enter the total number of marks in the exam: ");
#    scanf("%d",&max);
#    printf("Enter the number of marks the student was awarded: ");
#    scanf("%d",&mark);
#
#    printf("The student scored %d%% in this exam.\n",100*mark/max);
#    return 0;
#}

          .data
x:        .space 4             # int x;
y:        .space 4             # int y;
percentage: .word 100
ask_max:  .asciiz "Enter the total number of marks in the exam: "
ask_mark: .asciiz "Enter the number of marks the student was awarded: "
result_one: .asciiz "The student scored "
result_two: .asciiz "% in this exam. "
new_line:   .asciiz "\n"

#TODO add more here if needed

      .text
      .globl main
main:
      la    $a0, ask_max
      li    $v0, 4
      syscall                  # printf("Enter the total number of marks in the exam: ");
      
      li    $v0, 5
      syscall
      sw    $v0, x             # scanf("%d, &x"); 
      
      la    $a0, ask_mark
      li    $v0, 4
      syscall                  # printf("Enter the number of marks the student was awarded: ");
      
      li    $v0, 5
      syscall
      sw    $v0, y             # scanf("%d, &y");
      
      lw    $t0, x
      lw    $t1, y
      lw    $t2, percentage
      mul   $t1, $t1, $t2      # y = y * 100;
      divu  $t0, $t1, $t0      # x = y / x;
      
      la    $a0, result_one
      li    $v0, 4
      syscall                  # printf("The student scored ");
      
      li    $v0, 1             # printf("%d", x);
      move  $a0, $t0
      syscall
      
      la    $a0, result_two
      li    $v0, 4
      syscall                  # printf("% in this exam. ");
      
      la    $a0, new_line
      li    $v0, 4
      syscall                   #printf("\n");
      
      li  $v0, 0        # set return value to 0
      jr  $ra           # return from main

