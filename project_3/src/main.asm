# main source file

.org 0x10000000

li $sp 0x10FFFFFC

main:
    move $s0 $zero  # Left operand negative flag.
    move $s1 $zero  # Right operand negative flag.
    move $s2 $zero  # Left operand.
    move $s3 $zero  # Right operand.
    move $s4 $zero  # Operator
    move $s5 $zero  # Temp accumulator for building an operand
    j state_0
    nop
