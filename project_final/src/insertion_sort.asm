# Implement insertion sort here
# Input arguments:
#   $a0 - starting memory address of the array to be sorted
#   $a1 - number of elements in array
# More information about insertion sort can be found here:
# http://en.wikipedia.org/wiki/Insertion_sort

insertion_sort:
    ori $t9 $zero 4
    sll $a1 $a1 2
    insertion_while:
        slt $t7 $t9 $a1
        beq $t7 $zero end_insertion

        move $t8 $t9

        addu $s1 $a0 $t8
        addiu $s0 $s1 -4

        lw $t0 0($s0)
        lw $t1 0($s1)

        inner_insertion_while:
            slt $t7 $zero $t8
            slt $t6 $t1 $t0
            and $t7 $t7 $t6
            beq $t7 $zero end_inner_insertion_while

            addiu $t8 $t8 -4

            sw $t1 0($s0)
            sw $t0 0($s1)

            addu $s1 $a0 $t8
            addiu $s0 $s1 -4

            lw $t0 0($s0)
            lw $t1 0($s1)

            j inner_insertion_while
            nop
            end_inner_insertion_while:

        j insertion_while
        addiu $t9 $t9 4

end_insertion:
return
