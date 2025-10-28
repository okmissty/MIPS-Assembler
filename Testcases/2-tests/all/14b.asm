.main
# Testcase 14b
# setup
addi $t1, $zero, 4294902015       # t1 = 11111111111111110000000000000000 =4294901760 = 0xFFFF0000
# test
ori $t2, $t1, 255                 # t2 = $t1 | imm (255 = 0x00FF)
# Expected Output: t2 = 1111 1111 1111 1111 0000 0000 1111 1111 = 4294902015 = 0xFFFF00FF
