# You can implement any sorting algorithm you choose.  You can really go two ways with this: implement the simplest algorithm you can think of in as few lines as possible or take on a faster, but more complex algorithm like heapsort.
# Input arguments:
#   $a0 - starting memory address of the array to be sorted
#   $a1 - number of elements in array
# A comparison of a number of sorting algorithms you might attempt can be found here:
# https://en.wikipedia.org/wiki/Sorting_algorithm#Comparison_of_algorithms

wildcard_sort:
    ori $t9 $zero 0
    sll $a1 $a1 2
    addiu $a1 $a1 -4
    push $ra
    jal quick_sort_wrapper
    nop
    pop $ra
    return

quick_sort_wrapper:
    slt $t8 $t9 $a1
    beq $t8 $zero end_quick_sort
    nop

        push $ra
        push $t9
        push $a0

        push $t8
        push $a1

        jal partition
        nop

        pop $a1
        pop $t8

        move $t8 $a1
        #addiu $a1 $v0 -4
        move $a1 $v0

        push $t8
        push $a1

        jal quick_sort_wrapper
        nop

        pop $a1
        pop $t8
        pop $a0
        pop $t9

        addiu $t9 $a1 4
        move $a1 $t8

        push $t8
        push $t9
        push $a0
        push $a1

        jal quick_sort_wrapper
        nop

        pop $a1
        pop $a0
        pop $t9
        pop $t8
        pop $ra

    end_quick_sort:
    jr $ra
    nop


# a0 t9 a1
partition:
addu $t8 $a0 $t9
lw $t8 0($t8)  # pivot
addiu $t0 $t9 -4
addiu $t1 $a1 4

    partition_while:
        first_do_while:
            addiu $t1 $t1 -4
            addu $t2 $a0 $t1
            lw $t3 0($t2)

            slt $t6 $t8 $t3
            bne $t6 $zero first_do_while
            nop

        second_do_while:
            addiu $t0 $t0 4
            addu $t4 $a0 $t0
            lw $t5 0($t4)
            slt $t6 $t5 $t8
            bne $t6 $zero second_do_while
            nop

        slt $t6 $t0 $t1
        bne $t6 $zero swap
        nop
        move $v0 $t1
        jr $ra
        nop

        swap:
            sw $t5 0($t2)
            sw $t3 0($t4)
            j partition_while
            nop