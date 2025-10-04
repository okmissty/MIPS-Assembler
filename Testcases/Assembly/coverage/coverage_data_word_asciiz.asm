    # coverage_data_word_asciiz.asm
    # Tests .asciiz emission and .word referencing a data label
    .data
    msg:    .asciiz "Hi"
    ptr:    .word msg

    .text
    start:
      la $t0, ptr    # $t0 <- address of ptr (data)
      lw $t1, 0($t0) # $t1 <- address of msg (from ptr)
      la $a0, msg    # $a0 <- byte address of msg
      addi $v0, $zero, 10
      syscall
