.data
# memory.asm — exercises static memory layout, la, lw, sw, plus a call.
# Static memory starts at address 0; each .word consumes 4 bytes (per project).
# We place scalars and an array and store a function address as data.
value1: .word 4
funcptr: .word f                # address of function f (in bytes)
arr: .word 3 4 5 6              # simple array (4 elements)
negval: .word -12

.text
.globl main
main:
  # load addresses of labels using la (pseudoinstruction => addi)
  la   $t0, value1              # byte addr of value1
  la   $t1, arr                 # byte addr of arr
  la   $t2, funcptr             # byte addr of funcptr
  la   $t3, negval              # byte addr of negval

  # load/store words to/from static memory
  lw   $s0, 0($t0)              # s0 = value1 (4)
  addi $s0, $s0, 1              # s0 = 5
  sw   $s0, 0($t0)              # value1 <- 5

  lw   $s1, 0($t1)              # s1 = arr[0] (3)
  lw   $s2, 4($t1)              # s2 = arr[1] (4)
  add  $s3, $s1, $s2            # s3 = 7
  sw   $s3, 8($t1)              # arr[2] <- 7 (was 5)

  # read a negative from static memory
  lw   $s4, 0($t3)              # s4 = -12
  addi $s5, $zero, 2
  mult $s4, $s5                 # (-12) * 2 = -24
  mflo $s6                      # s6 = -24
  sw   $s6, 12($t1)             # arr[3] <- -24 (was 6)

  # call via function pointer loaded from memory
  lw   $t4, 0($t2)              # t4 = contents of funcptr (should be byte addr of f)
  jalr $t4                      # link in $ra, jump to f

  addi $v0, $zero, 10
  syscall

# function f: returns arr[0] + arr[1] in $v0
f:
  la   $a0, arr
  lw   $t0, 0($a0)
  lw   $t1, 4($a0)
  add  $v0, $t0, $t1            # v0 = 3 + 4 = 7 (before earlier overwrite)
  jr   $ra
