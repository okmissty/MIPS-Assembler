    # coverage_bge.asm
    # Tests bge pseudo-instruction (expands to slt and beq)
    .text
    main:
      addi $t0, $zero, 5
      addi $t1, $zero, 5
      bge $t0, $t1, GEQ
      addi $v0, $zero, 0
      j DONE
    GEQ:
      addi $v0, $zero, 1
    DONE:
      addi $v0, $v0, 10
      syscall
