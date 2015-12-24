# errors


invalid_character_error:
    li $a1 1
    call project3_output_number
    nop
    jal exhaust_bits
    nop
    j main
    nop


invalid_expression_error:
    li $a1 2
    call project3_output_number
    nop
    jal exhaust_bits
    nop
    j main
    nop


input_overflow_error:
    li $a1 3
    call project3_output_number
    nop
    jal exhaust_bits
    nop
    j main
    nop


output_overflow_error:
    li $a1 4
    call project3_output_number
    nop
    jal exhaust_bits
    nop
    j main
    nop

unknown_error:
    li $a1 5
    call project3_output_number
    nop
    jal exhaust_bits
    nop
    j main
    nop
