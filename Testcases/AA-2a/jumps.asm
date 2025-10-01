.data
.text
.globl main
# jumps.asm — exercises j, jal, jr, jalr (1-operand and 2-operand per spec).

main:
  addi $a0, $zero, 5

  # absolute jump + link to a subroutine
  jal f            # save (PC+4) in $ra, jump to f

  # upon return, test jalr (1-operand) to the same function
  addi $t0, $zero, 0
  addi $t1, $zero, 0
  la   $t0, g                    # $t0 <- byte address of g
  jalr $t0                       # link into $ra, jump to $t0

  # test an absolute jump that skips a block
  j   end_after_jump

skip_block:
  addi $t2, $zero, 123           # should be skipped
  addi $t3, $zero, 456           # should be skipped

end_after_jump:
  addi $v0, $zero, 10
  syscall

# simple function f: doubles $a0 and returns in $v0, then jr $ra
f:
  add  $v0, $a0, $a0             # v0 = a0 * 2
  jr   $ra

# function g: returns constant 7 via jalr path; return via jr $ra
g:
  addi $v0, $zero, 7
  jr   $ra
