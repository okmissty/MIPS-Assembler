.text
.globl main
# branches.asm — exercises beq/bne with forward and backward targets,
# including crossing over non-branch instructions and using both named
# and numbered registers.

main:
  addi $t0, $zero, 3       # i = 3
  addi $t1, $zero, 0       # sum = 0

loop:
  add  $t1, $t1, $t0       # sum += i
  addi $t0, $t0, -1        # i--
  bne  $t0, $zero, loop    # loop while i != 0

  # fallthrough: i == 0
  addi $t2, $zero, 42      # filler between branch and label

# Forward-branch test: skip over exactly one instruction
  beq  $t2, $t2, forward1  # always taken
  addi $t3, $zero, 999     # should be skipped

forward1:
  addi $9, $zero, 1        # $t1 is $9; set to 1 so we can compare

# Branch with zero offset (branch to the very next instruction after delay):
# The offset is computed relative to the next line, so target == next -> offset 0.
  beq  $9, $9, forward2    # true; encoded offset should be 0
forward2:
  addi $t4, $zero, -1

# Backward small-distance branch (two lines back to forward2)
  bne  $t4, $zero, forward2  # since $t4=-1, this goes back -- infinite loop

  # Finalize
  addi $v0, $zero, 10
  syscall
