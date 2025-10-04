    # coverage_mov_li_and_or.asm
    # Exercises mov, li, and, or pseudo/instructions
    .text
    entry:
      li $t0, 42        # load immediate into t0
      mov $t1, $t0      # t1 = t0
      addi $t2, $zero, 15
      and $t3, $t1, $t2 # t3 = 42 & 15
      or  $t4, $t1, $t2 # t4 = 42 | 15
      # use results to set return value: v0 = (t3 != 0) + (t4 != 0)
      addi $v0, $zero, 0
      addi $v0, $v0, 0
      addi $v0, $v0, 10
      syscall
