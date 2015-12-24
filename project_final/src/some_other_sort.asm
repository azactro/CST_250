# Implement bubble sort here
# Input arguments:
#   $a0 - starting memory address of the array to be sorted
#   $a1 - number of elements in array
# More information about bubble sort can be found here:
# http://en.wikipedia.org/wiki/Bubble_sort


other_sort:
    move $t0 $a0 # current
    sll $a1 $a1 2
    # declare $t1 candidate
    # declare $t2 lval
    # declare $t3 rval
    and $t4 $t4 $zero # i

    for_i_in:
        slt $t6 $t4 $a1
        beq $t6 $zero end_outer_iteration
        nop

        addu $t0 $a0 $t4 # current = current + i*4
        lw $t2 0($t0) # lval = *current

        addiu $t5 $t4 4 # j = i+1
        for_j_in:
            sltu $t6 $t5 $a1
            beq $t6 $zero end_inner_iteration
            nop

            addu $t1 $a0 $t5 # candidate = current + j*4
            lw $t3 0($t1) # rval = *candidate

            slt $t6 $t3 $t2
            bne $t6 $zero swap
            nop

            j for_j_in
            addiu $t5 $t5 1

            swap:
                sw $t2 0($t1)
                sw $t3 0($t0)
                move $t2 $t3
                j for_j_in
                addiu $t5 $t5 4

        end_inner_iteration:

        j for_i_in
        addiu $t4 $t4 4
    end_outer_iteration:

    return