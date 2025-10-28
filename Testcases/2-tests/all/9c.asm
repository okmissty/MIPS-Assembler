.main
# Testcase 9c
# setup
addi $t0, $zero, -1             # t0 = 1111 1111 1111 1111 1111 1111 1111 1111 = 4294967295 = 0xFFFFFFFF 
# test
srl $t1, $t0, 4                  # t1 = t0 >> 4
# Expected Output: $t1 = 0000 1111 1111 1111 1111 1111 1111 1111 = 268435455 = 0xFFFFFFF