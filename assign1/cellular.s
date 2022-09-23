########################################################################
# CP1521 20T3 --- assignment 1: a cellular automaton renderer
#
# Written by Tianwei MO, 5/10/2020.


# Maximum and minimum values for the 3 parameters.

MIN_WORLD_SIZE	=    1
MAX_WORLD_SIZE	=  128
MIN_GENERATIONS	= -256
MAX_GENERATIONS	=  256
MIN_RULE	=    0
MAX_RULE	=  255

# Characters used to print alive/dead cells.

ALIVE_CHAR	= '#'
DEAD_CHAR	= '.'

# Maximum number of bytes needs to store all generations of cells.

MAX_CELLS_BYTES	= (MAX_GENERATIONS + 1) * MAX_WORLD_SIZE

	.data

# `cells' is used to store successive generations.  Each byte will be 1
# if the cell is alive in that generation, and 0 otherwise.

cells:          	.space MAX_CELLS_BYTES


# Some strings you'll need to use:

prompt_world_size:	.asciiz "Enter world size: "
error_world_size:	.asciiz "Invalid world size\n"
prompt_rule:		.asciiz "Enter rule: "
error_rule:		.asciiz "Invalid rule\n"
prompt_n_generations:	.asciiz "Enter how many generations: "
error_n_generations:	.asciiz "Invalid number of generations\n"
	.text

	#
	# YOU SHOULD ALSO NOTE WHICH REGISTERS DO NOT HAVE THEIR
	# ORIGINAL VALUE WHEN `run_generation' FINISHES
	#

main:
    #  set up stack frame
	sw    $fp, -4($sp)       # push $fp onto stack
    la    $fp, -4($sp)       # set up $fp for this function
    sw    $ra, -4($fp)       # save return address
    sw    $s0, -8($fp)       # save $s0 to use as world_size;
    sw    $s1, -12($fp)      # save $s1 to use as rule;
    sw    $s2, -16($fp)      # save $s2 to use as n_generations;
    sw    $s3, -20($fp)      # save $s3 to use as reverse;
    sw    $s4, -24($fp)      # save $s4 to use as g;
    sw    $s5, -28($fp)      # save $s5 to use as min value;
    sw    $s6, -32($fp)      # save $s6 to use as max value;
    addi  $sp, $sp, -36      # reset $sp to last pushed item
    # Some use of $t registers:
    # $t0 is used as row of array;
    # $t1 is used as column of array;
    # $t2 is used as a random number;
    # $t3 is used as offset of middle of the world;

    la  $a0, prompt_world_size
    li  $v0, 4
    syscall                  # printf("Enter world size: ");
    
    li  $v0, 5
    syscall                  # scanf("%d", &world_size);
    move $s0, $v0            # $s0 = world_size;
    
if_world:
    li  $s5, MIN_WORLD_SIZE  # $s5 = MIN_WORLD_SIZE;
    li  $s6, MAX_WORLD_SIZE  # $s6 = MAX_WORLD_SIZE;
    blt $s0, $s5, invalid_world_size # if(world_size < MIN_WORLD_SIZE) goto invalid_world_size;
    bgt $s0, $s6, invalid_world_size # if(world_size > MAX_WORLD_SIZE) goto invalid_world_size;
    
    la  $a0, prompt_rule
    li  $v0, 4
    syscall                  # printf("Enter rule: ");
    
    li  $v0, 5
    syscall                  # scanf("%d", &rule);
    move $s1, $v0            # $s1 = rule;

if_rule:
    li  $s5, MIN_RULE  # $s5 = MIN_RULE;
    li  $s6, MAX_RULE  # $s6 = MAX_RULE;
    blt $s1, $s5, invalid_rule # if(rule < MIN_RULE) goto invalid_rule;
    bgt $s1, $s6, invalid_rule # if(rule > MAX_RULE) goto invalid_rule;
    
    la  $a0, prompt_n_generations
    li  $v0, 4
    syscall                  # printf("Enter how many generations: ");
    
    li  $v0, 5
    syscall                  # scanf("%d", &n_generations);
    move $s2, $v0            # $s2 = n_generations;
    
if_generations:
    li  $s5, MIN_GENERATIONS  # $s5 = MIN_GENERATIONS;
    li  $s6, MAX_GENERATIONS  # $s6 = MAX_GENERATIONS;
    blt $s2, $s5, invalid_generations # if(n_generations < MIN_GENERATIONS) goto invalid_generations;
    bgt $s2, $s6, invalid_generations # if(n_generations > MAX_GENERATIONS) goto invalid_generations;
    
    li  $a0, '\n'
    li  $v0, 11
    syscall                  # printf("\n");
    
    li  $s3, 0               # int reverse = 0;
if_negative_generations:
    bgez, $s2, end_if_negative_generations  # if(n_generations >= 0) goto end_if_negative_generations;
    li  $s3, 1               # reverse = 1;
    sub $s2, $0, $s2         # n_generations = 0 - n_generations;
    
end_if_negative_generations:
    
    li  $t0, 0               # $t0 is the row of array
    move $t1, $s0            # $t1 is the column of array
    li  $t3, 2               # $t3 = 2;
    div $t1, $t1, $t3        # column = world_size / 2;
    add $t2, $t0, $t1        # offset = $t0 + $t1;
    li  $t3, 1
    sb  $t3, cells($t2)      # cells[0][world_size / 2] = 1;
    
    li  $s4, 1               # int g = 1;
for_loop:
    bgt $s4, $s2, end_for_loop  # if(g > n_generations) goto end_for_loop;
    move $a0, $s0
    move $a1, $s1
    move $a2, $s4            # store passing values in $a registers
    jal run_generation       # run_generation(world_size, g, rule);
    addi $s4, $s4, 1         # g++;
    j   for_loop             # goto for_loop;
end_for_loop:

if_reverse:
    beqz $s3, print_negative_generation  # if(reverse == 0) goto print_negative_generation;
print_positive_generation:
    move $s4, $s2            # g = n_generations;
print_positive_loop:
    bltz $s4, end_print_positive_loop  # if(g < 0) goto end_print_positive_loop;
    move $a0, $s0
    move $a1, $s4            # store passing values in $a registers
    jal print_generation     # print_generation(world_size, g);
    addi $s4, $s4, -1        # g--;
    j   print_positive_loop  # goto print_positive_loop;
end_print_positive_loop:
    j   end_if_reverse

print_negative_generation:
    li   $s4, 0              # g = 0;
print_negative_loop:
    bgt $s4, $s2, end_print_negative_loop  # if(g > n_generations) goto end_print_negative_loop;
    move $a0, $s0
    move $a1, $s4            # store passing values in $a registers
    jal print_generation     # print_generation(world_size, g);
    addi $s4, $s4, 1         # g++;
    j   print_negative_loop  # goto print_negative_loop;
end_print_negative_loop:
    j   end_if_reverse
    
end_if_reverse:

    j   return0              # return 0;

invalid_world_size:
    la  $a0, error_world_size
    li  $v0, 4
    syscall                  # printf("Invalid world size\n");
    j   return1              # return 1;

invalid_rule:
    la  $a0, error_rule
    li  $v0, 4
    syscall                  # printf("Invalid rule\n");
    j   return1              # return 1;

invalid_generations:
    la  $a0, error_n_generations
    li  $v0, 4
    syscall                  # printf("Invalid number of generations\n");
    j   return1              # return 1;
    
return0:
    li  $v0, 0
    j   epilogue
    
return1:
    li  $v0, 1
    j   epilogue
epilogue:
    # clean up stack frame
    lw    $s6, -32($fp)      # restore $s6 value
    lw    $s5, -28($fp)      # restore $s5 value
    lw    $s4, -24($fp)      # restore $s4 value
    lw    $s3, -20($fp)      # restore $s3 value
    lw    $s2, -16($fp)      # restore $s2 value
    lw    $s1, -12($fp)      # restore $s1 value
    lw    $s0, -8($fp)       # restore $s0 value
    lw    $ra, -4($fp)       # restore $ra for return
    la    $sp, 4($fp)        # restore $sp (remove stack frame)
    lw    $fp, ($fp)         # restore $fp (remove stack frame)
    jr  $ra
    
	#
	# Given `world_size', `which_generation', and `rule', calculate
	# a new generation according to `rule' and store it in `cells'.
	#

	#
	# YOU SHOULD ALSO NOTE WHICH REGISTERS DO NOT HAVE THEIR
	# ORIGINAL VALUE WHEN `run_generation' FINISHES
	#

run_generation:
    #  set up stack frame
    sw    $fp, -4($sp)       # push $fp onto stack
    la    $fp, -4($sp)       # set up $fp for this function
    sw    $ra, -4($fp)       # save return address
    sw    $s0, -8($fp)       # save $s0 to use as world_size;
    sw    $s1, -12($fp)      # save $s1 to use as rule;
    sw    $s4, -16($fp)      # save $s4 to use as which_generation;
    addi  $sp, $sp, -20      # reset $sp to last pushed item
    
    # Some use of $t registers:
    # $t4 is use as x;
    # $t5 is used as left;
    # $t6 is used as centre;
    # $t7 is used as right;
    # $t8 is used as a random number;
    # $t9 is used as a random number;
    
    move $s0, $a0
    move $s1, $a1
    move $s4, $a2            # load passing values from $a registers
    
	li  $t4, 0               # int x = 0;
f1_for_loop:
    bge $t4, $s0, end_f1_for_loop  # if(x >= world_size) goto end_f1_for_loop;

    li  $t5, 0               # int left = 0;
    move $t8, $s0            # $t8 = world_size;
    move $t9, $s4            # $t9 = which_generation;
    addi $t9, $t9, -1        # $t9 = which_generation - 1;
    mul $t8, $t8, $t9        # $t8 = world_size * (which_generation - 1)
    add $t8, $t8, $t4        # $t8 = $t8 + x - 1
    addi $t8, $t8, -1        # offset of left cell
    
f1_if_left:
    blez, $t4, end_f1_if_left     # if(x <= 0) goto end_f1_if_left;
    lb  $t5, cells($t8)      # left = cells[which_generation - 1][x - 1];
end_f1_if_left:
    
    addi $t8, $t8, 1         # offset of centre cell
    lb  $t6, cells($t8)      # int centre = cells[which_generation - 1][x];
    
    li  $t7, 0               # int right = 0;
    move $t9, $s0            # $t9 = world_size;
    addi $t9, $t9, -1        # $t9 = world_size - 1;
f1_if_right:
    bge $t4, $t9, end_f1_if_right  # if(x >= word_size - 1) goto end_f1_if_right;
    addi $t8, $t8, 1         # offset of right cell
    lb  $t7, cells($t8)      # right = cells[which_generation - 1][x + 1];
end_f1_if_right:

    sll $t5, $t5, 2          # left = left << 2;
    sll $t6, $t6, 1          # centre = centre << 1;
    sll $t7, $t7, 0          # right = right << 0;
    or  $t8, $t5, $t6        # int state = left << 2 | centre << 1;
    or  $t8, $t8, $t7        # state = left << 2 | centre << 1 | right << 0;
    li  $t9, 1               # $t9 = 1;
    sllv $t9, $t9, $t8       # int bit = 1 << state;
    and $t8, $s1, $t9        # int set = rule & bit;
    
f1_if_set:
    move $t9, $s0            # $t9 = world_size
    mul $t9, $t9, $s4        # $t9 = world_size * which_generation;
    add $t9, $t9, $t4        # offset of the cell to be set
    
    beqz $t8, f1_else_set    # if(set == 0) goto f1_else_set;
    li  $t8, 1               # $t8 = 1;
    sb  $t8, cells($t9)      # cells[which_generation][x] = 1;
    j   end_f1_if_set
    
f1_else_set:
    li  $t8, 0               # $t8 = 0;
    sb  $t8, cells($t9)      # cells[which_generation][x] = 0;
    
end_f1_if_set:

    addi $t4, 1              # x++;
    j   f1_for_loop
    
end_f1_for_loop:

    # clean up stack frame
    lw    $s4, -16($fp)      # restore $s4 value
    lw    $s1, -12($fp)      # restore $s1 value
    lw    $s0, -8($fp)       # restore $s0 value
    lw    $ra, -4($fp)       # restore $ra for return
    la    $sp, 4($fp)        # restore $sp (remove stack frame)
    lw    $fp, ($fp)         # restore $fp (remove stack frame)
    
	jr	$ra


	#
	# Given `world_size', and `which_generation', print out the
	# specified generation.
	#

	#
	# YOU SHOULD ALSO NOTE WHICH REGISTERS DO NOT HAVE THEIR
	# ORIGINAL VALUE WHEN `print_generation' FINISHES
	#

print_generation:
    #  set up stack frame
    sw    $fp, -4($sp)       # push $fp onto stack
    la    $fp, -4($sp)       # set up $fp for this function
    sw    $ra, -4($fp)       # save return address
    sw    $s0, -8($fp)       # save $s0 to use as world_size;
    sw    $s4, -12($fp)      # save $s4 to use as x;
    addi  $sp, $sp, -16      # reset $sp to last pushed item
    
    # Some use of $t registers:
    # $t4 is used as x;
    # $t9 is used as a random number;
    
    move $s0, $a0
    move $s4, $a1            # load passing values from $a registers
    
    move $a0, $s4            # $a0 = which_generation;
    li  $v0, 1
    syscall                  # printf("%d", which_generation);
    
    li  $a0, '\t'            # $a0 = '\t'
    li  $v0, 11
    syscall                  # putchar('\t');
    
    li  $t4, 0               # int x = 0;
f2_for_loop:
    bge $t4, $s0, end_f2_for_loop  # if(x >= word_size) goto end_f2_for_loop;
    
f2_if:
    move $t9, $s0            # $t9 = world_size
    mul $t9, $t9, $s4        # $t9 = world_size * which_generation;
    add $t9, $t9, $t4        # offset of the cell
    lb  $t9, cells($t9)      # $t9 = cells[which_generation][x]
    beqz $t9, f2_else        # if(cells[which_generation][x] == 0) goto f2_else;
    li  $a0, ALIVE_CHAR
    li  $v0, 11
    syscall                  # putchar(ALIVE_CHAR);
    
    j   end_f2_if
f2_else:
    li  $a0, DEAD_CHAR
    li  $v0, 11
    syscall                  # putchar(DEAD_CHAR);
    
end_f2_if:
    
    addi $t4, $t4, 1         # x++;
    j   f2_for_loop
end_f2_for_loop:

    li  $a0, '\n'
    li  $v0, 11
    syscall                  # putchar('\n');

    # clean up stack frame
    lw    $s4, -12($fp)      # restore $s4 value
    lw    $s0, -8($fp)       # restore $s0 value
    lw    $ra, -4($fp)       # restore $ra for return
    la    $sp, 4($fp)        # restore $sp (remove stack frame)
    lw    $fp, ($fp)         # restore $fp (remove stack frame)
    
	jr	$ra
