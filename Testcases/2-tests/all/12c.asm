.main
# Testcase 12c
# setup
addi $t0, $zero, 65535              # t0 = 0000 0000 0000 0000 1111 1111 1111 1111 = 65535 = 0x0000FFFF
# test
andi $t1, $t0, 255                  # t1 = t0 & imm (255 = 0x000000FF)
# Expected Output: t1 = 0000 0000 0000 0000 0000 0000 1111 1111 = 255 = 0x000000FF