.text
.globl main
# arithmetic.asm — exercises arithmetic/shift/multiply/divide/slt encodings
# Mixes named and numbered registers and includes negative immediates.
# No static memory used here.

main:
  # initialize some registers
  addi $t0, $zero, 12      # $t0 = 12
  addi $9,  $zero, -5      # $t1 is $9 = -5 (0xFFFB)
  add  $t2, $t0, $9        # $t2 = 12 + (-5) = 7
  sub  $t3, $t0, $9        # $t3 = 12 - (-5) = 17

  # shifts
  sll  $t3, $t2, 2         # $t3 = 7 << 2 = 28
  srl  $t4, $t2, 1         # $t4 = 7 >> 1 = 3

  # mult/div + mfhi/mflo
  mult $t3, $t0            # 28 * 12 = 224 -> LO, HI=0
  mflo $t5                 # $t5 = 336
  addi $t6, $zero, 5
  div  $t5, $t6            # 336 / 5 -> LO = 67, HI = 1
  mflo $t7                 # $t7 = 67
  mfhi $s0                 # $s0 = 1

  # set-less-than (signed)
  slt  $s1, $9, $t0        # (-5) < 12 ? 1 : 0  -> $s1 = 1
  slt  $s2, $t0, $9        # 12 < (-5) ? -> 0

  # a couple more arithmetic combos
  addi $s3, $s1, 10        # $s3 = 11
  add  $s4, $s3, $t7       # $s4 = 11 + 67 = 78

  # end program
  addi $v0, $zero, 10      # syscall 10
  syscall
