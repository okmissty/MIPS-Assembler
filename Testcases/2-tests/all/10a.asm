.main
# Testcase 10a
# setup
addi $t0, $zero, -1             # $t0 = -1
addi $t1, $zero, 1              # $t1 = 1
# test
slt $t2, $t0, $t1               # $t2 = 1 (since -1<1)
# Expected Output: $t2 = 1
