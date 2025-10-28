.main
# Testcase 10b
# setup
addi $t0, $zero, 5              # $t0 = 5
addi $t1, $zero, -3             # $t1 = -3
# test
slt $t2, $t0, $t1               # $t2 = 0 (since 5 !< -3)
# Expected Output: $t2 = 0