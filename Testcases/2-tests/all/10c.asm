.main
# Testcase 10c
# setup
addi $t0, $zero, 7              # $t0 = 7
addi $t1, $zero, 7              # $t1 = 7
# test
slt $t2, $t0, $t1               # $t2 = 0 (since 7 !< 7)
# Expected Output: $t2 = 0