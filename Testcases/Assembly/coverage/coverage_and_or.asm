    # coverage_and_or.asm
    # Verify AND/OR semantics with zero and nonzero masks
    .text
    main:
      addi $t0, $zero, 0xF0
      addi $t1, $zero, 0x0F
      and $t2, $t0, $t1   # expect 0
      or  $t3, $t0, $t1   # expect 0xFF
      addi $v0, $zero, 10
      syscall
