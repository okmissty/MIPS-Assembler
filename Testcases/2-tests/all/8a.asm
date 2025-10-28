.main
# Testcase 8a
# setup
addi $t0, $zero, 3              # t0 = 3
# test
sll $t1, $t0, 4                  # t1 = t0 << 4
# Expected Output: $t1 = 48 = 0x00000030