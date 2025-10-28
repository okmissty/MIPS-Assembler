.main
# Testcase 12b
# setup
addi $t0, $zero, 4294902015         # t0 = 1111 1111 1111 1111 0000 0000 0000 0000 = 4294902015 = 0xFFFF00FF
# test
andi $t1, $t0, 64512                 # t1 = t0 & imm (64512 = 0xFC00)
# Expected Output: t1 = 0000 0000 0000 0000 0000 0000 0000 0000 = 0 = 0x00000000