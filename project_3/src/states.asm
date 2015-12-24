# Implementations of the project 3 state machine.


# $s0  Left operand negative flag.
# $s1  Right operand negative flag.
# $s2  Left operand.
# $s3  Right operand.
# $s4  Operator
# $s5  Temp accumulator for building an operand


state_0:
    jal get_uart
    nop
    move $a0 $v0
    li $t0 45  # Hyphen
    beq $a0 $t0 state_1b
    nop
    jal is_operator
    nop
    bne $v0 $zero invalid_expression_error
    nop
    li $t0 61  # Equals sign
    beq $a0 $t0 invalid_expression_error
    nop
    jal is_numeric
    nop
    beq $v0 $zero invalid_character_error
    nop
    jal append_to_left_value
    nop
    j state_1a
    nop


state_1b:
    li $s0 1
    jal get_uart
    nop
    move $a0 $v0
    jal is_operator
    nop
    bne $v0 $zero invalid_expression_error
    nop
    li $t0 61  # Equals sign
    beq $a0 $t0 invalid_expression_error
    nop
    jal is_numeric
    nop
    beq $v0 $zero invalid_character_error
    nop
    jal append_to_left_value
    nop
    j state_1a
    nop


state_1a:
    jal get_uart
    nop
    move $a0 $v0
    jal is_operator
    nop
    bne $zero $v0 state_2_transition
    nop
    li $t0 61  # Equals sign
    beq $a0 $t0 invalid_expression_error
    nop
    jal is_numeric
    nop
    beq $v0 $zero invalid_character_error
    nop
    jal append_to_left_value
    nop
    j state_1a
    nop


state_2_transition:
    move $s4 $a0
    move $s2 $s5
    move $s5 $zero
    j state_2
    nop


state_2:
    jal get_uart
    nop
    move $a0 $v0
    li $t0 45  # Hyphen
    beq $a0 $t0 state_3a
    nop
    jal is_operator
    nop
    bne $v0 $zero invalid_expression_error
    nop
    li $t0 61  # Equals sign
    beq $a0 $t0 invalid_expression_error
    nop
    jal is_numeric
    nop
    beq $v0 $zero invalid_character_error
    nop
    jal append_to_right_value
    nop
    j state_3b
    nop


state_3a:
    li $s1 1
    jal get_uart
    nop
    move $a0 $v0
    jal is_operator
    nop
    bne $v0 $zero invalid_expression_error
    nop
    li $t0 61  # Equals sign
    beq $a0 $t0 invalid_expression_error
    nop
    jal is_numeric
    nop
    beq $v0 $zero invalid_character_error
    nop
    jal append_to_right_value
    nop
    j state_3b
    nop


state_3b:
    jal get_uart
    nop
    move $a0 $v0
    jal is_operator
    nop
    bne $v0 $zero compound_eval_transition
    nop
    li $t0 61  # Equals sign
    beq $a0 $t0 final_eval_transition
    nop
    jal is_numeric
    nop
    beq $v0 $zero invalid_character_error
    nop
    jal append_to_right_value
    nop
    j state_3b
    nop


compound_eval_transition:
    push $a0
    move $s3 $s5
    jal arithmetic
    nop
    move $s2 $v0
    srl $s0 $s2 31
    pop $a0
    move $s4 $a0
    move $s3 $zero
    move $s1 $zero
    move $s5 $zero
    j state_2
    nop


final_eval_transition:
    move $s3 $s5
    jal arithmetic
    nop
    move $a0 $v0
    li $a1 0
    call project3_output_number
    nop
    j main
    nop
