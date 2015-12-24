# Implement bubble sort here
# Input arguments:
#   $a0 - starting memory address of the array to be sorted
#   $a1 - number of elements in array
# More information about bubble sort can be found here:
# http://en.wikipedia.org/wiki/Bubble_sort

bubble_sort:
    move $t8 $a1

    _bubble_sort:
    beq $t8 $zero bubble_done

    move $t7 $a0
    ori $s1 $zero 1
    # int* t0;
    # int* t1;
    # int t2;
    # int t3;
    bubble_loop:
        slt $t9 $s1 $t8
            beq $t9 $zero end_bubble_loop

        move $t0 $t7
        addiu $t1 $t7 4
        lw $t2 0($t0)
        lw $t3 0($t1)
        slt $t9 $t3 $t2
        beq $t9 $zero continue_bubble_loop
        addiu $t7 $t7 4

        # Swap
        sw $t3 0($t0)
        sw $t2 0($t1)

    continue_bubble_loop:
        j bubble_loop
        addiu $s1 $s1 1

    end_bubble_loop:
        j _bubble_sort
        addiu $t8 $t8 -1

bubble_done:
jr $ra
nop