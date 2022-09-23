# COMP1521 18s1 Exam Q1
# int isIdent(int matrix[N][N], int N)

   .text
   .globl isIdent

# params: matrix=$a0, N=$a1
isIdent:
# prologue
   addi $sp, $sp, -4
   sw   $fp, ($sp)
   la   $fp, ($sp)
   addi $sp, $sp, -4
   sw   $ra, ($sp)
   addi $sp, $sp, -4
   sw   $s0, ($sp)
   addi $sp, $sp, -4
   sw   $s1, ($sp)
   addi $sp, $sp, -4
   sw   $s2, ($sp)
   addi $sp, $sp, -4
   sw   $s3, ($sp)
   # if you need to save more than four $s? registers
   # add extra code here to save them on the stack

# ... your code for the body of isIdent(m,N) goes here ...
    li  $t0, 0
    li  $t1, 0
for_one:
    bge $t0, $a1, end_for_one
    
for_two:
    bge $t1, $a1, end_for_two

    mul $t3, $t0, $a1
    add $t3, $t3, $t1
    sll $t3, $t3, 2
    add $t3, $a0, $t3
    lw  $t3, ($t3)
    li  $t4, 1
if:
    bne $t0, $t1, or
    beq $t3, $t4, or
    j   return0
    
or:
    beq $t0, $t1, end_if
    beq $t3, $t4, end_if
    j   return0
    
end_if:

    addi $t1, $t1, 1
end_for_two

    addi $t0, $t0, 1
end_for_one:
    li  $v0, 1
    j   the_end
    
return0:
    li  $v0, 0
    j   the_end
    
the_end:
# epilogue
   # if you saved more than six $s? registers
   # add extra code here to restore them
   lw   $s3, ($sp)
   addi $sp, $sp, 4
   lw   $s2, ($sp)
   addi $sp, $sp, 4
   lw   $s1, ($sp)
   addi $sp, $sp, 4
   lw   $s0, ($sp)
   addi $sp, $sp, 4
   lw   $ra, ($sp)
   addi $sp, $sp, 4
   lw   $fp, ($sp)
   addi $sp, $sp, 4
   j    $ra

