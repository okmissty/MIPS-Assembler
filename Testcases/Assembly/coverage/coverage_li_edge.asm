    # coverage_li_edge.asm
    # Tests li with negative and large immediates (fits 16-bit)
    .text
    li_test:
      li $t0, -1
      li $t1, 32767
      li $t2, -32768
      add $v0, $t0, $t1
      add $v0, $v0, $t2
      addi $v0, $v0, 10
      syscall
