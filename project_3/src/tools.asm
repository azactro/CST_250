# Tools for project 3.
#
# Includes:
#   append_to_left_value
#   append_to_right_value
#   get_uart


append_to_left_value:
    push $t0
    push $a0
    move $t0 $ra
    move $a0 $s0
    jal will_overflow
    nop
    bne $v0 $zero input_overflow_error
    nop
    jal _enlarge_accumulator
    nop
    move $ra $t0
    pop $a0
    pop $t0
    andi $a0 $a0 0b1111  # Save ASCII to $a0
    bne $s0 $zero _append_value_negative
    nop
    beq $s0 $zero _append_value_positive
    nop


append_to_right_value:
    push $t0
    push $a0
    move $t0 $ra
    move $a0 $s1
    jal will_overflow
    nop
    bne $v0 $zero input_overflow_error
    nop
    jal _enlarge_accumulator
    nop
    move $ra $t0
    pop $a0
    pop $t0
    andi $a0 $a0 0b1111  # Save ASCII to $a0
    bne $s1 $zero _append_value_negative
    nop
    beq $s1 $zero _append_value_positive
    nop


_append_value_negative:
    subu $s5 $s5 $a0
    push $t0
    li $t0 0x80000000
    and $t0 $t0 $s5
    beq $t0 $zero input_overflow_error
    nop
    pop $t0
    jr $ra
    nop


_append_value_positive:
    addu $s5 $s5 $a0
    push $t0
    li $t0 0x80000000
    and $t0 $t0 $s5
    bne $t0 $zero input_overflow_error
    nop
    pop $t0
    jr $ra
    nop


_enlarge_accumulator:
    push $ra
    push $t0
    push $t1
    push $t2
    push $t3

    move $t0 $s5  # Copy current accumulator
    li $t1 10
    mulhi $t2 $t0 $t1  # Mulhi copy of accumulator
    mullo $t3 $t0 $t1  # Mullo copy of accumulator

    beq $a0 $zero _concatenate_positive
    nop
    bne $a0 $zero _concatenate_negative
    nop

    _return_enlarge:
        move $s5 $t0
        pop $t3
        pop $t2
        pop $t1
        pop $t0
        pop $ra
        jr $ra
        nop

_concatenate_positive:
    or $t0 $t2 $t3
    j _return_enlarge
    nop


_concatenate_negative:
    and $t0 $t2 $t3
    j _return_enlarge
    nop

get_uart:
    push $t0
    push $t1

    # UART Location.
    li $t0 0xF0000000
    li $t1 0b10

    _wait_for_input:
        # Check if we have any input, wait until otherwise.
        lw $t2 4($t0)
        and $t2 $t2 $t1
        bne $t1 $t2 _wait_for_input
        nop

    # Retrieve value.
    lw $v0 8($t0)

    # Reset ready bit
    lw $t1 0($t0)
    ori $t1 $t1 0b10
    sw $t1 0($t0)

    pop $t1
    pop $t0
    jr $ra
    nop


consume_bad_expression:
    # UART Location.
    push $t0
    push $t1
    push $t2
    li $t0 0xF0000000

    _consume_expression:
        # Check if we have any input.
        # If not, then we are at the end of the expression.
        lw $t0 4($t0)
        andi $t0 $t0 0b10
        bne $t0 $t1 _consumed_expression

        # Retrieve value.
        lw $v0 8($t0)

        # Reset ready bit
        lw $t1 0($t0)
        ori $t1 $t1 0b10
        sw $t1 0($t0)

        li $t2 61  # = symbol
        bne $t1 $t2 _consume_expression
        nop

    _consumed_expression:
        pop $t2
        pop $t1
        pop $t0
        jr $ra
        nop


exhaust_bits:
    li $t1 0xF0000000
    lw $t0 4($t1)
    andi $t0 $t0 0x0002 # mask ready bit
    beq $t0 $zero _exhaust_bits_return # if ready bit == 0
    nop
    li $t0 0x0002
    sw $t0 0($t1) # write 1 to clear status bit
    j exhaust_bits
    nop


_exhaust_bits_return:
    jr $ra
    nop