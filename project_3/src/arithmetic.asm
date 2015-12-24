arithmetic:
    li $t0 0x2a # asterisk
    beq $s4 $t0 multiplication
    nop
    li $t0 0x2b # plus sign
    beq $s4 $t0 addition
    nop
    li $t0 0x2d # hyphen
    beq $s4 $t0 subtraction
    nop

_arithmetic_end:
    jr $ra
    nop


# Multiplication
multiplication:
    li $v0 0
    beq $s2 $zero _arithmetic_end
    nop
    beq $s3 $zero _arithmetic_end
    nop
    li $t0 1
    beq $t0 $s2 _one_left_multiplication  # Short circuit trivial multiplication.
    nop
    beq $t0 $s3 _one_right_multiplication  # Short circuit trivial multiplication.
    nop
    li $t0 -1
    beq $t0 $s2 _neg_one_left_multiplication  # Short circuit trivial multiplication.
    nop
    beq $t0 $s3 _neg_one_right_multiplication  # Short circuit trivial multiplication.
    nop
    push $ra
    mullo $t0 $s2 $s3
    move $a0 $t0
    move $a1 $s3
    jal signed_division
    nop
    bne $s2 $v0 output_overflow_error
    nop
    move $v0 $t0
    pop $ra
    j _arithmetic_end
    nop

    _one_left_multiplication:
        move $v0 $s3
        j _arithmetic_end
        nop

    _one_right_multiplication:
        move $v0 $s2
        j _arithmetic_end
        nop

    _neg_one_left_multiplication:
        li $t1 -2147483648
        beq $t1 $s3 output_overflow_error
        nop
        mullo $v0 $s3 $t0
        j _arithmetic_end
        nop

    _neg_one_right_multiplication:
        li $t1 -2147483648
        beq $t1 $s2 output_overflow_error
        nop
        mullo $v0 $s2 $t0
        j _arithmetic_end
        nop


# Addition and subtraction
addition:
    bne $s0 $s1 _addition_diff_sign
    nop

    li $t0 1

    _addition_anchor1:
        addu $v0 $s2 $s3
        bne $t0 $zero _addition_same_sign
        nop

    _addition_anchor2:
        j _arithmetic_end
        nop


_addition_diff_sign:
    li $t0 0
    j _addition_anchor1
    nop


_addition_same_sign:
    srl $t2 $v0 31
    bne $s0 $t2 output_overflow_error
    nop
    j _addition_anchor2


subtraction:
    beq $s0 $s1 _subtraction_same_sign
    nop

    li $t0 1

    _subtraction_anchor1:
        subu $v0 $s2 $s3
        bne $t0 $zero _subtraction_diff_sign
        nop

    _subtraction_anchor2:
        j _arithmetic_end
        nop


_subtraction_same_sign:
    li $t0 0
    j _subtraction_anchor1
    nop


_subtraction_diff_sign:
    srl $t2 $v0 31
    bne $s0 $t2 output_overflow_error
    nop
    j _subtraction_anchor2
    nop