# Implements psuedo code from:
# http://bisqwit.iki.fi/story/howto/bitmath/#DivAndModDivisionAndModulo
# Author: Joel Yliluoma

# $a0 / $a1

unsigned_division:
    push $ra
    push $t0
    push $t1
    push $t2
    push $t3

    move $v0 $zero
    beq $a1 $zero _zero_division
    nop
    beq $a0 $a1 _equal_operands
    nop
    move $t0 $a0  # $t0 dividend
    move $t1 $a1  # $t1 divisor
    li $t2 1  # mask
    align:
        sltu $t3 $t1 $t0
        bne $t3 $zero _shift_left
        nop
    _do:
        sltu $t3 $t1 $t0 # divisor < dividend
        bne $t3 $zero _math
        nop
        subu $t3 $t1 $t0
        beq $t3 $zero _math
        nop
    _while:
        srl $t1 $t1 1
        srl $t2 $t2 1
        bne $t2 $zero _do
        nop

    pop $t3
    pop $t2
    pop $t1
    pop $t0
    pop $ra
    jr $ra
    nop

signed_division:
    push $ra
    push $t0
    push $t1
    push $t2
    push $t3
    push $t4
    push $t5

    #move $t6 $ra  # Save the original ra
    move $t0 $a0  # Dividend
    move $t1 $a1  # Divisor
    move $t2 $zero  # Sign
    _check_negatives:
        slti $t3 $t0 0 # if (a < 0)
        bne $t3 $zero _negate_dividend
        nop
        _continue_negative_check:
        slti $t3 $t1 0 # if (a < 0)
        bne $t3 $zero _negate_divisor
        nop
    _end_negative_check:
    move $a0 $t0
    move $a1 $t1
    jal unsigned_division
    nop
    bne $t2 $zero _negate_result
    nop
    _done_with_division:
        pop $t5
        pop $t4
        pop $t3
        pop $t2
        pop $t1
        pop $t0
        pop $ra
        jr $ra
        nop

_negate_dividend:
    jal _toggle_sign
    li $t3 0xFFFFFFFF
    mulhi $t4 $t0 $t3
    mullo $t5 $t0 $t3
    addu $t0 $t4 $t5
    j _continue_negative_check
    nop

_negate_divisor:
    jal _toggle_sign
    li $t3 0xFFFFFFFF
    mulhi $t4 $t1 $t3
    mullo $t5 $t1 $t3
    addu $t1 $t4 $t5
    j _end_negative_check
    nop

_negate_result:
    nor $v0 $v0 $zero
    addiu $v0 $v0 1
    j _done_with_division
    nop

_toggle_sign:
    nor $t2 $t2 $zero
    jr $ra
    nop

_math:
    subu $t0 $t0 $t1
    addu $v0 $v0 $t2
    j _while
    nop

_shift_left:
    sll $t1 $t1 1
    sll $t2 $t2 1
    j align
    nop

_zero_division:
   li $v0 0
   jr $ra
   nop

_equal_operands:
    li $v0 1
    jr $ra
    nop
