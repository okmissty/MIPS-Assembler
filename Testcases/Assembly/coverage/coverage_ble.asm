    # coverage_ble.asm
    # Tests ble pseudo-instruction (expands to slt and bne)
    .text
    start:
      addi $t0, $zero, 3
      addi $t1, $zero, 4
      ble $t0, $t1, LEQ
      addi $v0, $zero, 0
      j END
    LEQ:
      addi $v0, $zero, 2
    END:
      addi $v0, $v0, 10
      syscall
