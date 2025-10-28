.main
# Testcase 9b
# setup
addi $t0, $zero, 1              # t0 = 0000 0000 0000 0000 0000 0000 0000 0001
# test
srl $t1, $t0, 1                  # t1 = t0 >> 1
# Expected Output: $t1 = 0000 0000 0000 0000 0000 0000 0000 0000 = 0 = 0x00000000