.main
# Testcase 8b
# setup
addi $t0, $zero, 1              # t0 = 1
# test
sll $t1, $t0, 31                 # t1 = t0 << 31
# Expected Output: $t1 = 2147483648 = 0x80000000
