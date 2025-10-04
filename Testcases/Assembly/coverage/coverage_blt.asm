    # coverage_blt.asm
    # Tests blt pseudo-instruction (expands to slt and bne)
    .text
    foo:
      addi $t0, $zero, -1
      addi $t1, $zero, 0
      blt $t0, $t1, LESS
      addi $v0, $zero, 0
      j FIN
    LESS:
      addi $v0, $zero, 3
    FIN:
      addi $v0, $v0, 10
      syscall
