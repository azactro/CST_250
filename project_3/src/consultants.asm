# Consultants for project 3.
#
# Questions:
#   is_numeric
#   is_operator


is_numeric:
    push $t0
    push $t1
    push $t2

    li $t2 47
    sltu $t0 $t2 $a0  # (47 < val) ? 1 : 0
    sltiu $t1 $a0 58  # (val < 58) ? 1 : 0
    and $v0 $t0 $t1

    pop $t2
    pop $t1
    pop $t0
    jr $ra
    nop

is_operator:
    # * 42
    # + 43
    # - 45
    push $t0
    move $v0 $zero
    li $t0 42
    beq $a0 $t0 _is_operator_set_true # *
    nop
    li $t0 43
    beq $a0 $t0 _is_operator_set_true # +
    nop
    li $t0 45
    beq $a0 $t0 _is_operator_set_true # -
    nop
    _is_operator_return:
        pop $t0
        jr $ra
        nop
    _is_operator_set_true:
        li $v0 1
        j _is_operator_return
        nop


will_overflow:
    # Takes is $a0 to indicate desired signage.
    #   0 - Positive
    #   1 - Negative
    #
    # Predicts whether or not enlarging the current accumulator
    # by multiplying it by 10 will cause an overflow.
    push $t0
    beq $a0 $zero _positive_prediction
    nop
    bne $a0 $zero _negative_prediction
    nop
    _positive_prediction:
        li $t0 214748364
        sltu $v0 $t0 $s5
        j _return_prediction
        nop
    _negative_prediction:
        li $t0 -214748364
        slt $v0 $s5 $t0
    _return_prediction:
        pop $t0
        jr $ra
        nop