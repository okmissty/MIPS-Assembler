.main
# Testcase 17b
# setup
addi $t0, $zero, -1             # $t0 = 0x
addi $t1, $zero, -1             # $t1 = 0xFFFFFFFF
# test
nor $t2, $t0, $t1               # $t2 = $t0 ~| $t1
# Expected Output: $t2 = 00000000000000000000000000000000 = 0 = 0x00000000